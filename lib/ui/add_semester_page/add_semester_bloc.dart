import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gpa_cal/util/log.dart';
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

  AddSemesterBloc(BuildContext context) : super(AddSemesterState.initialState) {
    on<ErrorEvent>(_onErrorEvent);
    on<AddSubjectsEvent>(_onAddSubjectsEvent);
    on<DeleteSubjectEvent>(_onDeleteSubjectEvent);
    on<TotalErrorEvent>(_onTotalErrorEvent);
    on<ConfirmEvent>(_onConfirmEvent);
  }

  void _onErrorEvent(ErrorEvent event, Emitter<AddSemesterState> emit) {
    log.e('Error: ${event.error}');
    emit(state.clone(error: ""));
    emit(state.clone(error: event.error));
  }

  void _onAddSubjectsEvent(AddSubjectsEvent event, Emitter<AddSemesterState> emit) {
    emit(state.clone(loading: true));
    final index = event.index;
    final singleSubject = event.subject;
    final subjects = state.subjects;
    var totalError = false;
    subjects[index] = singleSubject;

    final totalResult = state.totalResult;
    final totalCredit = state.totalCredit;

    // [result , credit]
    totalResult[index] = ['', ''];

    var emptySubjects = [];
    print('Index is');
    print(index);
    print('Single Subject is');
    print(singleSubject);

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
        totalResult, totalCredit, event.gpaType);

    log.e(sgpa.toString());

    log.e('Add Subjects Event Called Subjects: ');
    print(subjects);
    log.e('Empty Tasks :');
    print(emptySubjects);
    print(totalError);

    emit(state.clone(
      subjects: subjects,
      emptySubjects: emptySubjects,
      totalError: totalError,
      sgpa: sgpa,
      loading: false,
    ));
  }

  void _onDeleteSubjectEvent(DeleteSubjectEvent event, Emitter<AddSemesterState> emit) {
    emit(state.clone(loading: true));
    final index = event.index;
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
      event.gpaType,
    );

    log.e(sgpa.toString());

    emit(state.clone(
      subjects: subjects,
      emptySubjects: emptySubjects,
      sgpa: sgpa,
      loading: false,
    ));
    print(subjects);
    print(emptySubjects);
    log.e('Delete Subject Event called');
    this.add(TotalErrorEvent());
  }

  void _onTotalErrorEvent(TotalErrorEvent event, Emitter<AddSemesterState> emit) {
    final subjects = state.subjects;
    final emptySubjects = state.emptySubjects;
    var totalError = false;
    if (emptySubjects.isNotEmpty) {
      emit(state.clone(totalError: true, loading: false));
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
      emit(state.clone(totalError: totalError, loading: false));
    }
    log.e('Total Error Event called');
  }

  Future<void> _onConfirmEvent(ConfirmEvent event, Emitter<AddSemesterState> emit) async {
    emit(state.clone(loading: true));
    final name = event.name;
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
            subjects.toString() +
            DateTime.now().toString())
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
      emit(state.clone(semester: semester, loading: false));
    } on CacheError {
      add(ErrorEvent('Stroage Limit Exceed!'));
    } catch (e) {
      add(ErrorEvent('UNEXPECTED FATAL ERROR!'));
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
  void onError(Object error, StackTrace stackTrace) {
    log.e('$stackTrace');
    log.e('$error');
    _addErr(error);
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(dynamic e) {
    if (e is StateError) {
      return;
    }
    try {
      String msg = "Something went wrong. Please try again !";
      if (e is String) {
        msg = e;
      } else {
        try {
          msg = (e as dynamic).message ?? msg;
        } catch (_) {}
      }
      add(ErrorEvent(msg));
    } catch (err) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }
}
