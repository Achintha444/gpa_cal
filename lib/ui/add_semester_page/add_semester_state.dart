import 'package:flutter/material.dart';

import '../../db/model/semester.dart';

@immutable
class AddSemesterState {
  final bool loading;
  final String error;
  final Map<int, Map> subjects;

  /// if one is empty, add index to emptySubjects
  final List emptySubjects;
  final bool totalError;
  final Map totalResult;
  final Map totalCredit;
  final double sgpa;
  
  // final Semester object is saved here
  final Semester semester;

  AddSemesterState({
    @required this.loading,
    @required this.error,
    @required this.subjects,
    @required this.emptySubjects,
    @required this.totalError,
    @required this.totalResult,
    @required this.totalCredit,
    @required this.sgpa,
    @required this.semester,
  });

  static AddSemesterState get initialState => AddSemesterState(
        loading: false,
        error: '',
        subjects: {},
        emptySubjects: [],
        totalError: true,
        totalCredit: {},
        totalResult: {},
        sgpa: 0,
        semester: null,
      );

  AddSemesterState clone({
    bool loading,
    String error,
    Map<int, Map> subjects,
    List emptySubjects,
    bool totalError,
    Map totalResult,
    Map totalCredit,
    double sgpa,
    Semester semester,
  }) {
    return AddSemesterState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      subjects: subjects ?? this.subjects,
      emptySubjects: emptySubjects ?? this.emptySubjects,
      totalError: totalError ?? this.totalError,
      sgpa: sgpa ?? this.sgpa,
      totalCredit: totalCredit ?? this.totalCredit,
      totalResult: totalResult ?? this.totalResult,
      semester: semester ?? this.semester
    );
  }
}
