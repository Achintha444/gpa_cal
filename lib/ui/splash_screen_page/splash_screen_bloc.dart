import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gpa_cal/util/log.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_details_model.dart';
import 'package:gpa_cal/db/repo/splash_screen_repo.dart';
import 'package:gpa_cal/util/errors.dart';

import 'splash_screen_event.dart';
import 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  static final log = Log("SplashScreenBloc");
  static final SplashScreenRepo _splashScreenRepo = new SplashScreenRepo();

  SplashScreenBloc(BuildContext context)
      : super(SplashScreenState.initialState) {
    on<ErrorEvent>(_onErrorEvent);
    on<SplashFormEvent>(_onSplashFormEvent);
    on<LoadHomeScreenEvent>(_onLoadHomeScreenEvent);
    this._initialize();
  }

  Future<void> _initialize() async {
    try {
      UserDetailsModel _userDetailsModel = await _splashScreenRepo.autoChange();
      await Future.delayed(Duration(seconds: 2));
      add(LoadHomeScreenEvent(_userDetailsModel));
    } on CacheNotPresentError {
      await Future.delayed(Duration(seconds: 2));
      add(SplashFormEvent(true));
    } on CacheError {
      add(ErrorEvent('Stroage Limit Exceed!'));
    } catch (e) {
      add(ErrorEvent('UNEXPECTED FATAL ERROR!'));
    }
  }

  void _onErrorEvent(ErrorEvent event, Emitter<SplashScreenState> emit) {
    log.e('Error: ${event.error}');
    emit(state.clone(error: event.error));
  }

  void _onSplashFormEvent(SplashFormEvent event, Emitter<SplashScreenState> emit) {
    emit(state.clone(loading: true));
    log.e('Cache Not Present: ${event.cacheNotPresent}');
    emit(state.clone(cacheNotPresent: event.cacheNotPresent, loading: false));
  }

  void _onLoadHomeScreenEvent(LoadHomeScreenEvent event, Emitter<SplashScreenState> emit) {
    emit(state.clone(loading: true));
    log.e('Load Home Screen Event called');
    emit(state.clone(userDetailsModel: event.userDetailsModel, loading: false));
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    log.e('$stackTrace');
    log.e('$error');
    _addErr(error);
    super.onError(error, stackTrace);
  }

  @override
  Future<void> close() async {
    await super.close();
  }

  void _addErr(dynamic e) {
    if (e is StateError) {
      return;
    }
    try {
      String msg = "Something went wrong. Please try again !";
      if (e is String) {
        msg = e;
      } else {
        try {
          msg = (e as dynamic).message ?? msg;
        } catch (_) {}
      }
      add(ErrorEvent(msg));
    } catch (err) {
      add(ErrorEvent("Something went wrong. Please try again !"));
    }
  }
}
