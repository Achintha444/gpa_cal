import 'package:flutter/material.dart';

@immutable
abstract class AddSemesterEvent {}

class ErrorEvent extends AddSemesterEvent {
  final String error;

  ErrorEvent(this.error);
}
