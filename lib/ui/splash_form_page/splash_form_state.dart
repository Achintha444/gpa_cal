import 'package:flutter/material.dart';

@immutable
class SplashFormState {
  final String error;
  final bool formLoading;
  final bool formLoaded;

  SplashFormState({
    @required this.error,
    @required this.formLoading,
    @required this.formLoaded,
  });

  static SplashFormState get initialState => SplashFormState(
        error: '',
        formLoaded: false,
        formLoading: false,
      );

  SplashFormState clone({
    String error,
    bool formLoading,
    bool formLoaded,
  }) {
    return SplashFormState(
      error: error ?? this.error,
      formLoading: formLoading ?? this.formLoading,
      formLoaded: formLoaded ?? this.formLoaded,
    );
  }
}
