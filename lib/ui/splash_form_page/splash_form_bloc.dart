import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';

import '../../db/model/user_details_model.dart';
import '../../db/repo/splash_form_repo.dart';
import '../../util/errors.dart';
import 'splash_form_event.dart';
import 'splash_form_state.dart';

class SplashFormBloc extends Bloc<SplashFormEvent, SplashFormState> {
  static final log = Log("SplashFormBloc");
  static final SplashFormRepo _splashFormRepo = new SplashFormRepo();

  SplashFormBloc(BuildContext context) : super(SplashFormState.initialState);

  @override
  Stream<SplashFormState> mapEventToState(SplashFormEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error);
        break;

      case UserDetailsAddEvent:
        yield state.clone(formLoading: true);
        final UserDetailsModel _userDetailsModel = new UserDetailsModel(
          name: (event as UserDetailsAddEvent).name,
          uni: (event as UserDetailsAddEvent).uni,
          gpaType: (event as UserDetailsAddEvent).gpaType,
        );

        try {
          await _splashFormRepo.insertUserDetails(_userDetailsModel);
          yield state.clone(userDetailsModel: _userDetailsModel, formLoading: false);
        } on CacheError {
          add(ErrorEvent('Stroage Limit Exceed!'));
        } catch (e) {
          add(ErrorEvent('UNEXPECTED FATAL ERROR!'));
        }
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
