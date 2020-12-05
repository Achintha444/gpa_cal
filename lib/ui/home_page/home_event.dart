import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_result.dart';

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
