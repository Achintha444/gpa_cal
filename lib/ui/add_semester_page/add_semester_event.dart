import 'package:flutter/material.dart';

@immutable
abstract class AddSemesterEvent {}

class ErrorEvent extends AddSemesterEvent {
  final String error;

  ErrorEvent(this.error);
}

class AddSubjectsEvent extends AddSemesterEvent {
  final Map subject;
  final int index;

  AddSubjectsEvent(this.subject, this.index);
}

class DeleteSubjectEvent extends AddSemesterEvent {
  final int index;

  DeleteSubjectEvent(this.index);
}

class TotalErrorEvent extends AddSemesterEvent {}
