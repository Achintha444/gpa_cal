import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/db/repo/splash_screen_repo.dart';
import 'package:gpa_cal/util/errors.dart';

import 'splash_screen_event.dart';
import 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  static final log = Log("SplashScreenBloc");
  final SplashScreenRepo _splashScreenRepo = new SplashScreenRepo();

  SplashScreenBloc(BuildContext context)
      : super(SplashScreenState.initialState) {
    this._initialize();
  }

  Future<void> _initialize() async {
    try {
      await this._splashScreenRepo.autoChange();
    } on CacheNotPresentError {
      await Future.delayed(Duration(seconds: 2));
      add(SplashFormEvent(true));
    } on CacheError {
      add(ErrorEvent('Stroage Limit Exceed!'));
    } catch (e) {}
  }

  @override
  Stream<SplashScreenState> mapEventToState(SplashScreenEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: error);
        break;
      case SplashFormEvent:
        final cacheNotPresent = (event as SplashFormEvent).cacheNotPresent;
        log.e('Cache Not Present: $cacheNotPresent');
        yield state.clone(cacheNotPresent:  cacheNotPresent, loading: false);
        break;
    }
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    log.e('$stacktrace');
    log.e('$error');
    _addErr(error);
    super.onError(error, stacktrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(e) {
    if (e is StateError) {
      return;
    }
    try {
      add(ErrorEvent(
        (e is String)
            ? e
            : (e.message ?? "Something went wrong. Please try again !"),
      ));
    } catch (e) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }
}
