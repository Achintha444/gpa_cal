import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_result.dart';

@immutable
class HomeState {
  final String error;
  final bool loading;
  final bool cacheNotPresent;

  // UserResults are in here
  final UserResultModel userResultModel;

  HomeState({
    @required this.error,
    @required this.loading,
    @required this.cacheNotPresent,
    @required this.userResultModel,
  });

  static HomeState get initialState => HomeState(
        error: '',
        loading: true,
        cacheNotPresent: false,
        userResultModel: null,
      );

  HomeState clone({
    String error,
    bool loading,
    bool cacheNotPresent,
    UserResultModel userResultModel,
  }) {
    return HomeState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      cacheNotPresent: cacheNotPresent ?? this.cacheNotPresent,
      userResultModel: userResultModel ?? this.userResultModel
    );
  }
}
