import 'package:flutter/material.dart';

@immutable
abstract class SplashFormEvent {}

class ErrorEvent extends SplashFormEvent {
  final String error;

  ErrorEvent(this.error);
}

class UserDetailsAddEvent extends SplashFormEvent {
  final String name;
  final String uni;
  final int gpaType;

  UserDetailsAddEvent({required this.name, required this.uni, required this.gpaType});
}
