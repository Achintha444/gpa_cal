import 'package:flutter/material.dart';

@immutable
class AddSemesterState {
  final String error;
  final Map<int,Map> subjects;
  /// if one is empty, add index to emptySubjects
  final List emptySubjects;
  final bool totalError;

  AddSemesterState({
    @required this.error,
    @required this.subjects,
    @required this.emptySubjects,
    @required this.totalError,
  });

  static AddSemesterState get initialState => AddSemesterState(
    error: '',
    subjects: {},
    emptySubjects: [],
    totalError: true,
  );

  AddSemesterState clone({
    String error,
    Map<int,Map> subjects,
    List emptySubjects,
    bool totalError,
  }) {
    return AddSemesterState(
      error: error ?? this.error,
      subjects: subjects ?? this.subjects,
      emptySubjects: emptySubjects ?? this.emptySubjects,
      totalError: totalError ?? this.totalError
    );
  }
}
