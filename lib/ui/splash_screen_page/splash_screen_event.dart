import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';

@immutable
abstract class SplashScreenEvent {}

class ErrorEvent extends SplashScreenEvent {
  final String error;

  ErrorEvent(this.error);
}

class SplashFormEvent extends SplashScreenEvent {
  final bool cacheNotPresent;

  SplashFormEvent(this.cacheNotPresent);
}

class LoadHomeScreenEvent extends SplashScreenEvent {
  final UserDetailsModel userDetailsModel;

  LoadHomeScreenEvent(this.userDetailsModel);
}
