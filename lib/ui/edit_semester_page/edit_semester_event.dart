import 'package:flutter/material.dart';

@immutable
abstract class EditSemesterEvent {}

class ErrorEvent extends EditSemesterEvent {
  final String error;

  ErrorEvent(this.error);
}

class EditSubjectsEvent extends EditSemesterEvent {
  final Map subject;
  final int index;
  final int gpaType;
  EditSubjectsEvent(this.subject, this.index, this.gpaType);
}

class DeleteEditSubjectEvent extends EditSemesterEvent {
  final int index;
  final int gpaType;
  DeleteEditSubjectEvent(this.index, this.gpaType);
}

class TotalErrorEvent extends EditSemesterEvent{}

class ConfirmEvent extends EditSemesterEvent {
  final String name;

  ConfirmEvent(this.name);
}
