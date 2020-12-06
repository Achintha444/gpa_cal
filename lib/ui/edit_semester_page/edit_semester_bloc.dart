import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/semester.dart';
import 'package:gpa_cal/db/repo/home_repo.dart';
import 'package:gpa_cal/util/db_util/gpa_conversion.dart';
import 'package:gpa_cal/util/errors.dart';

import 'edit_semester_event.dart';
import 'edit_semester_state.dart';

class EditSemesterBloc extends Bloc<EditSemesterEvent, EditSemesterState> {
  static final log = Log("EditSemesterBloc");
  static final _homeRepo = new HomeRepo();
  final Semester semester;

  EditSemesterBloc(BuildContext context, this.semester)
      : super(EditSemesterState.initialState(semester));

  @override
  Stream<EditSemesterState> mapEventToState(EditSemesterEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;
      case EditSubjectsEvent:
        yield state.clone(loading: true);
        final index = (event as EditSubjectsEvent).index;
        final singleSubject = (event as EditSubjectsEvent).subject;
        final subjects = state.subjects;
        var totalError = false;
        subjects[index] = singleSubject;

        final totalResult = state.totalResult;
        final totalCredit = state.totalCredit;

        // [result , credit]
        totalResult[index] = ['', ''];

        var emptySubjects = [];

        subjects.forEach((key, value) {
          var _count = 0;
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
            totalResult, totalCredit, (event as EditSubjectsEvent).gpaType);

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
            loading: false);
        break;

      case DeleteEditSubjectEvent:
        yield state.clone(loading: true);
        final index = (event as DeleteEditSubjectEvent).index;
        final subjects = state.subjects;
        final emptySubjects = state.emptySubjects;
        subjects.remove(index);
        emptySubjects.remove(index);

        final totalResult = state.totalResult;
        final totalCredit = state.totalCredit;

        totalCredit.remove(index);
        totalResult.remove(index);

        final sgpa = GpaConversion.returnSgpa(totalResult, totalCredit,
            (event as DeleteEditSubjectEvent).gpaType);

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
      case DeleteEditeSemesterEvent :
        yield state.clone(loading: true);
        final deleteSemester = (event as DeleteEditeSemesterEvent).deleteSemester;
        await _homeRepo.deleteSemester(deleteSemester);
        log.e('Delete Semester Event called');
        yield state.clone(deleteSemester: deleteSemester, loading: false);
        break;
      case EditConfirmEvent:
        yield state.clone(loading: true);
        final name = (event as EditConfirmEvent).name;
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
          //await _addSemesterRepo.addSemesterLocally(semester);
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
