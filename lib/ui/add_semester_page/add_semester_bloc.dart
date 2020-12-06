import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/semester.dart';
import 'package:gpa_cal/util/errors.dart';

import '../../db/repo/add_semester_repo.dart';
import '../../util/db_util/gpa_conversion.dart';
import 'add_semester_event.dart';
import 'add_semester_state.dart';

class AddSemesterBloc extends Bloc<AddSemesterEvent, AddSemesterState> {
  static final log = Log("AddSemesterBloc");
  static final AddSemesterRepo _addSemesterRepo = new AddSemesterRepo();

  AddSemesterBloc(BuildContext context) : super(AddSemesterState.initialState);

  @override
  Stream<AddSemesterState> mapEventToState(AddSemesterEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;

      case AddSubjectsEvent:
        yield state.clone(loading: true);
        final index = (event as AddSubjectsEvent).index;
        final singleSubject = (event as AddSubjectsEvent).subject;
        final subjects = state.subjects;
        var totalError = false;
        subjects[index] = singleSubject;

        final totalResult = state.totalResult;
        final totalCredit = state.totalCredit;

        // [result , credit]
        totalResult[index] = ['', ''];

        var emptySubjects = [];
        print('Index is');
        print (index);
        print ('Single Subject is');
        print (singleSubject);

        subjects.forEach((key, value) {
          var _count = 0;
          print(value);
          print('xxxxxxxxxx');
          value.forEach((key1, value1) {
            if (key1 == 'result') {
              totalResult[key][0] = value1;
            } else if (key1 == 'credit') {
              totalResult[key][1] = value1;
              totalCredit[key] = value1;
            }

            _count += 1;
            if (value1 == '' || value1.trim().isEmpty) {
              emptySubjects.add(key);
              totalError = true;
            }
          });
          if (_count != 3) {
            totalError = true;
          }
          print(totalResult);
          print(totalCredit);
          print('=====');
        });

        final sgpa = GpaConversion.returnSgpa(
            totalResult, totalCredit, (event as AddSubjectsEvent).gpaType);

        log.e(sgpa.toString());

        log.e('Add Subjects Event Called Subjects: ');
        print(subjects);
        log.e('Empty Tasks :');
        print(emptySubjects);
        print(totalError);

        yield state.clone(
          subjects: subjects,
          emptySubjects: emptySubjects,
          totalError: totalError,
          sgpa: sgpa,
          loading: false,
        );
        break;

      case DeleteSubjectEvent:
        yield state.clone(loading: true);
        final index = (event as DeleteSubjectEvent).index;
        final subjects = state.subjects;
        final emptySubjects = state.emptySubjects;
        subjects.remove(index);
        emptySubjects.remove(index);

        final totalResult = state.totalResult;
        final totalCredit = state.totalCredit;

        totalCredit.remove(index);
        totalResult.remove(index);

        final sgpa = GpaConversion.returnSgpa(
          totalResult,
          totalCredit,
          (event as DeleteSubjectEvent).gpaType,
        );

        log.e(sgpa.toString());

        yield state.clone(
          subjects: subjects,
          emptySubjects: emptySubjects,
          sgpa: sgpa,
          loading: false,
        );
        print(subjects);
        print(emptySubjects);
        log.e('Delete Subject Event called');
        this.add(TotalErrorEvent());
        break;

      case TotalErrorEvent:
        final subjects = state.subjects;
        final emptySubjects = state.emptySubjects;
        var totalError = false;
        if (emptySubjects.isNotEmpty) {
          yield state.clone(totalError: true, loading: false);
        } else {
          subjects.forEach((key, value) {
            var _count = 0;
            value.forEach((key1, value1) {
              _count += 1;
              if (value1 == '' || value1.trim().isEmpty) {
                totalError = true;
              }
            });
            if (_count != 3) {
              totalError = true;
            }
          });
          yield state.clone(totalError: totalError, loading: false);
        }
        log.e('Total Error Event called');
        break;

      case ConfirmEvent:
        yield state.clone(loading: true);
        final name = (event as ConfirmEvent).name;
        final sgpa = state.sgpa;
        final totalCreditMap = state.totalCredit;
        final subjectsMap = state.subjects;

        final totalCredit = _calculateTotalCredit(totalCreditMap);
        final totalResult = sgpa * totalCredit;
        final subjects = _returnSubjectList(subjectsMap);

        final hash = (name +
                sgpa.toString() +
                totalCredit.toString() +
                totalResult.toString() +
                subjects.toString())
            .hashCode;

        final semester = new Semester(
          hash: hash,
          name: name,
          sgpa: sgpa,
          totalResult: totalResult,
          totalCredit: totalCredit,
          subjectList: subjects,
        );

        try {
          await _addSemesterRepo.addSemesterLocally(semester);
          yield state.clone(semester: semester, loading: false);
        } on CacheError {
          add(ErrorEvent('Stroage Limit Exceed!'));
        } catch (e) {
          add(ErrorEvent('UNEXPECTED FATAL ERROR!'));
        }

        break;
    }
  }

  double _calculateTotalCredit(Map totalCreditMap) {
    var _totalCredit = 0.0;
    totalCreditMap.forEach((key, credit) {
      _totalCredit += double.parse(credit);
    });
    return _totalCredit;
  }

  List<Map> _returnSubjectList(Map<int, Map> subjectsMap) {
    List<Map> _subjects = [];
    subjectsMap.forEach((key, subject) {
      _subjects.add(subject);
    });
    return _subjects;
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    log.e('$stacktrace');
    log.e('$error');
    _addErr(error);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    if (e is StateError) {
      return;
    }
    try {
      add(ErrorEvent(
        (e is String)
            ? e
            : (e.message ?? "Something went wrong. Please try again !"),
      ));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }
}
