import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gpa_cal/util/log.dart';
import 'package:flutter/material.dart';

import '../../db/model/user_details_model.dart';
import '../../db/repo/splash_form_repo.dart';
import '../../util/errors.dart';
import 'splash_form_event.dart';
import 'splash_form_state.dart';

class SplashFormBloc extends Bloc<SplashFormEvent, SplashFormState> {
  static final log = Log("SplashFormBloc");
  static final SplashFormRepo _splashFormRepo = new SplashFormRepo();

  SplashFormBloc(BuildContext context) : super(SplashFormState.initialState) {
    on<ErrorEvent>(_onErrorEvent);
    on<UserDetailsAddEvent>(_onUserDetailsAddEvent);
  }

  void _onErrorEvent(ErrorEvent event, Emitter<SplashFormState> emit) {
    log.e('Error: ${event.error}');
    emit(state.clone(error: ""));
    emit(state.clone(error: event.error));
  }

  Future<void> _onUserDetailsAddEvent(UserDetailsAddEvent event, Emitter<SplashFormState> emit) async {
    emit(state.clone(formLoading: true));
    final UserDetailsModel _userDetailsModel = new UserDetailsModel(
      name: event.name,
      uni: event.uni,
      gpaType: event.gpaType,
    );

    try {
      await _splashFormRepo.insertUserDetails(_userDetailsModel);
      emit(state.clone(userDetailsModel: _userDetailsModel, formLoading: false));
    } on CacheError {
      add(ErrorEvent('Stroage Limit Exceed!'));
    } catch (e) {
      add(ErrorEvent('UNEXPECTED FATAL ERROR!'));
    }
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
