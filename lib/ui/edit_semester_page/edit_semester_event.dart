import 'package:flutter/material.dart';

@immutable
abstract class EditSemesterEvent {}

class ErrorEvent extends EditSemesterEvent {
  final String error;

  ErrorEvent(this.error);
}
