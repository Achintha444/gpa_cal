import 'package:flutter/material.dart';

@immutable
class SplashScreenState {
  final String error;

  SplashScreenState({
    @required this.error,
  });

  static SplashScreenState get initialState => SplashScreenState(
    error: '',
  );

  SplashScreenState clone({
    String error,
  }) {
    return SplashScreenState(
      error: error ?? this.error,
    );
  }
}
