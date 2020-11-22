import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

@immutable
class SplashFormState {
  final String error;
  final bool formLoading;
  final UserDetailsModel userDetailsModel;

  SplashFormState({
    @required this.error,
    @required this.formLoading,
    @required this.userDetailsModel,
  });

  static SplashFormState get initialState => SplashFormState(
        error: '',
        formLoading: false,
        userDetailsModel: null,
      );

  SplashFormState clone({
    String error,
    bool formLoading,
    UserDetailsModel userDetailsModel,
  }) {
    return SplashFormState(
      error: error ?? this.error,
      formLoading: formLoading ?? this.formLoading,
      userDetailsModel : userDetailsModel ?? this.userDetailsModel
    );
  }
}
