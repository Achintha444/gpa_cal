import 'package:flutter/material.dart';

@immutable
class HomeState {
  final String error;
  final bool loading;
  final bool cacheNotPresent;

  HomeState({
    @required this.error,
    @required this.loading,
    @required this.cacheNotPresent,
  });

  static HomeState get initialState => HomeState(
        error: '',
        loading: true,
        cacheNotPresent: false,
      );

  HomeState clone({
    String error,
    bool loading,
    bool cacheNotPresent,
  }) {
    return HomeState(
      error: error ?? this.error,
      loading: loading ?? this.loading,
      cacheNotPresent: cacheNotPresent ?? this.cacheNotPresent,
    );
  }
}
