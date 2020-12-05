import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/semester.dart';
import 'package:gpa_cal/db/model/user_result.dart';

@immutable
class HomeState {
  final String error;
  final bool loading;
  final bool cacheNotPresent;
  final Semester deleteSemester;

  // UserResults are in here
  final UserResultModel userResultModel;

  HomeState({
    @required this.error,
    @required this.loading,
    @required this.cacheNotPresent,
    @required this.userResultModel,
    @required this.deleteSemester,
  });

  static HomeState get initialState => HomeState(
        error: '',
        loading: true,
        cacheNotPresent: false,
        userResultModel: null,
        deleteSemester: null,
      );

  HomeState clone({
    String error,
    bool loading,
    bool cacheNotPresent,
    UserResultModel userResultModel,
    Semester deleteSemester,
  }) {
    return HomeState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      cacheNotPresent: cacheNotPresent ?? this.cacheNotPresent,
      userResultModel: userResultModel ?? this.userResultModel,
      deleteSemester: deleteSemester ?? this.deleteSemester,
    );
  }
}
