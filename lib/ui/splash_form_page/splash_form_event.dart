import 'package:flutter/material.dart';

@immutable
abstract class SplashFormEvent {}

class ErrorEvent extends SplashFormEvent {
  final String error;

  ErrorEvent(this.error);
}
