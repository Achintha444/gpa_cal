import 'package:flutter/material.dart';

@immutable
class AddSemesterState {
  final String error;

  AddSemesterState({
    @required this.error,
  });

  static AddSemesterState get initialState => AddSemesterState(
    error: '',
  );

  AddSemesterState clone({
    String error,
  }) {
    return AddSemesterState(
      error: error ?? this.error,
    );
  }
}
