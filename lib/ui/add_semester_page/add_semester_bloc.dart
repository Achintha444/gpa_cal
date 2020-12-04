import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/util/db_util/gpa_conversion.dart';

import 'add_semester_event.dart';
import 'add_semester_state.dart';

class AddSemesterBloc extends Bloc<AddSemesterEvent, AddSemesterState> {
  static final log = Log("AddSemesterBloc");

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

        subjects.forEach((key, value) {
          var _count = 0;
          value.forEach((key1, value1) {
            if (key1 == 'result') {
              totalResult[index][0] = value1;
            } else if (key1 == 'credit') {
              totalResult[index][1] = value1;
              totalCredit[index] = value1;
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
          print (totalCredit);
          print('=====');
        });

        log.e(GpaConversion.returnSgpa(totalResult, totalCredit, (event as AddSubjectsEvent).gpaType).toString());

        log.e('Add Subjects Event Called Subjects: ');
        print(subjects);
        log.e('Empty Tasks :');
        print(emptySubjects);
        print(totalError);

        yield state.clone(
          subjects: subjects,
          emptySubjects: emptySubjects,
          totalError: totalError,
        );
        break;

      case DeleteSubjectEvent:
        final index = (event as DeleteSubjectEvent).index;
        final subjects = state.subjects;
        final emptySubjects = state.emptySubjects;
        subjects.remove(index);
        emptySubjects.remove(index);
        yield state.clone(subjects: subjects, emptySubjects: emptySubjects);
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
          yield state.clone(totalError: true);
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
          yield state.clone(totalError: totalError);
        }
        log.e('Total Error Event called');
        break;
    }
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
