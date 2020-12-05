import 'package:flutter/material.dart';

import '../../db/model/semester.dart';
import '../../db/model/user_result.dart';

@immutable
abstract class HomeEvent {}

class ErrorEvent extends HomeEvent {
  final String error;

  ErrorEvent(this.error);
}

class FirstInterfaceEvent extends HomeEvent{
  final bool cacheNotPresent;

  FirstInterfaceEvent(this.cacheNotPresent);
}

class HomeInterfaceEvent extends HomeEvent {
  final UserResultModel userResultModel;

  HomeInterfaceEvent(this.userResultModel);
}

class DeleteSemesterEvent extends HomeEvent{
  final Semester deleteSemester;

  DeleteSemesterEvent(this.deleteSemester);
}
