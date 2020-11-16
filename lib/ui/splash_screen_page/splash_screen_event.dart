import 'package:flutter/material.dart';

@immutable
abstract class SplashScreenEvent {}

class ErrorEvent extends SplashScreenEvent {
  final String error;

  ErrorEvent(this.error);
}

class SplashFormEvent extends SplashScreenEvent {
  final bool cacheNotPresent;

  SplashFormEvent(this.cacheNotPresent);
}
