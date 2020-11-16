import 'package:flutter/material.dart';

@immutable
class SplashScreenState {
  final String error;
  final bool cacheNotPresent;
  final bool loading;

  SplashScreenState({
    @required this.error,
    @required this.cacheNotPresent,
    @required this.loading,
  });

  static SplashScreenState get initialState => SplashScreenState(
    error: '',
    cacheNotPresent: true,
    loading: true,
  );

  SplashScreenState clone({
    String error,
    bool cacheNotPrsent,
    bool loading
  }) {
    return SplashScreenState(
      error: error ?? this.error,
      cacheNotPresent: cacheNotPresent ?? this.cacheNotPresent,
      loading: loading ?? this.loading,
    );
  }
}
