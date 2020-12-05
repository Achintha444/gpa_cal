import 'package:flutter/material.dart';

@immutable
class EditSemesterState {
  final String error;

  EditSemesterState({
    @required this.error,
  });

  static EditSemesterState get initialState => EditSemesterState(
    error: '',
  );

  EditSemesterState clone({
    String error,
  }) {
    return EditSemesterState(
      error: error ?? this.error,
    );
  }
}
