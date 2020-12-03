import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';

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
        subjects[index] = singleSubject;

        var emptySubjects = [];

        subjects.forEach((key, value) {
          value.forEach((key1, value1) {
            if (value1 == '' || value1.trim().isEmpty) {
              emptySubjects.add(key);
            }
          });
        });

        log.e('Add Subjects Event Called Subjects: ');
        print(subjects);
        log.e('Empty Tasks :');
        print(emptySubjects);

        yield state.clone(subjects: subjects, emptySubjects: emptySubjects);
        break;
      case DeleteSubjectEvent:
        final index = (event as DeleteSubjectEvent).index;
        final subjects = state.subjects;
        final emptySubjects = state.emptySubjects;
        subjects.remove(index);
        emptySubjects.remove(index);
        yield state.clone(subjects: subjects, emptySubjects: emptySubjects);
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
