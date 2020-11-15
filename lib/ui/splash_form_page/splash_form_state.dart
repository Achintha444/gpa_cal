import 'package:flutter/material.dart';

@immutable
class SplashFormState {
  final String error;

  SplashFormState({
    @required this.error,
  });

  static SplashFormState get initialState => SplashFormState(
    error: '',
  );

  SplashFormState clone({
    String error,
  }) {
    return SplashFormState(
      error: error ?? this.error,
    );
  }
}
