import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/semester.dart';

@immutable
class EditSemesterState {
  final bool loading;
  final String error;
  final String name;
  final Map<int, Map> subjects;

  /// if one is empty, add index to emptySubjects
  final List emptySubjects;
  final bool totalError;
  final Map totalResult;
  final Map totalCredit;
  final double sgpa;

  final Semester semester;

  EditSemesterState({
    @required this.loading,
    @required this.error,
    @required this.name,
    @required this.subjects,
    @required this.emptySubjects,
    @required this.totalError,
    @required this.totalResult,
    @required this.totalCredit,
    @required this.sgpa,
    @required this.semester,
  });

  static EditSemesterState get initialState => EditSemesterState(
        loading: false,
        error: '',
        name: '',
        subjects: {},
        emptySubjects: [],
        totalError: true,
        totalCredit: {},
        totalResult: {},
        sgpa: 0,
        semester: null,
      );

  EditSemesterState clone({
    bool loading,
    String error,
    String name,
    Map<int, Map> subjects,
    List emptySubjects,
    bool totalError,
    Map totalResult,
    Map totalCredit,
    double sgpa,
    Semester semester,
  }) {
    return EditSemesterState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        name: name ?? this.name,
        subjects: subjects ?? this.subjects,
        emptySubjects: emptySubjects ?? this.emptySubjects,
        totalError: totalError ?? this.totalError,
        sgpa: sgpa ?? this.sgpa,
        totalCredit: totalCredit ?? this.totalCredit,
        totalResult: totalResult ?? this.totalResult,
        semester: semester ?? this.semester);
  }
}
