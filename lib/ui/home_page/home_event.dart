import 'package:flutter/material.dart';

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
