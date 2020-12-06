import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/semester.dart';

//TODO Remove Loaded
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

  final Semester deleteSemester;
  final bool loaded;
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
    @required this.deleteSemester,
    @required this.loaded,
    @required this.semester,
  });

  static EditSemesterState initialState(Semester semester) {
    /*
    {course: c, result: C, credit: 2.0}
     */

    Map<int,Map> _subjects = {};
    Map<int,String> _totalCredit = {};
    Map<int,List> _totalResult = {};
    int _i = 0;

    semester.subjectList.forEach((subject) {
      _subjects[_i] = subject;
      _totalCredit[_i] = subject['credit'];
      _totalResult[_i] = [subject['result'], subject['credit']];
      _i+=1;
    });

    return EditSemesterState(
      loading: false,
      error: '',
      name: semester.name,
      subjects: _subjects,
      emptySubjects: [],
      totalError: false,
      totalCredit: _totalCredit,
      totalResult: _totalResult,
      sgpa: semester.sgpa,
      deleteSemester: null,
      loaded: false,
      semester: semester,
    );
  }

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
    Semester deleteSemester,
    bool loaded,
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
      deleteSemester: deleteSemester ?? this.deleteSemester,
      loaded: loaded ?? this.loaded,
      semester: semester ?? this.semester,
    );
  }
}
