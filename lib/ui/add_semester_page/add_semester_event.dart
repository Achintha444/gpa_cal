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
  final int gpaType;
  AddSubjectsEvent(this.subject, this.index, this.gpaType);
}

class DeleteSubjectEvent extends AddSemesterEvent {
  final int index;
  final int gpaType;
  DeleteSubjectEvent(this.index, this.gpaType);
}

class TotalErrorEvent extends AddSemesterEvent {}

class ConfirmEvent extends AddSemesterEvent {
  final String name;

  ConfirmEvent(this.name);
}
