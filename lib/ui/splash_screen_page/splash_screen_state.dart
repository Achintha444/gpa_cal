import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

@immutable
class SplashScreenState {
  final String error;
  final bool cacheNotPresent;
  final bool loading;
  final UserDetailsModel userDetailsModel;

  SplashScreenState({
    @required this.error,
    @required this.cacheNotPresent,
    @required this.loading,
    @required this.userDetailsModel,
  });

  static SplashScreenState get initialState => SplashScreenState(
    error: '',
    cacheNotPresent: false,
    loading: true,
    userDetailsModel: null
  );

  SplashScreenState clone({
    String error,
    bool cacheNotPresent,
    bool loading,
    UserDetailsModel userDetailsModel,
  }) {
    return SplashScreenState(
      error: error ?? this.error,
      cacheNotPresent: cacheNotPresent ?? this.cacheNotPresent,
      loading: loading ?? this.loading,
      userDetailsModel : userDetailsModel ?? this.userDetailsModel
    );
  }
}
