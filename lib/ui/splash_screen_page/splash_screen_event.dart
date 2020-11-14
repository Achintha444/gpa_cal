import 'package:flutter/material.dart';

@immutable
abstract class SplashScreenEvent {}

class ErrorEvent extends SplashScreenEvent {
  final String error;

  ErrorEvent(this.error);
}
