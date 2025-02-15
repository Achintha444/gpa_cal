import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fcode_common/fcode_common.dart';
import 'package:flutter/material.dart';
import 'package:gpa_cal/db/model/user_result.dart';
import 'package:gpa_cal/db/repo/home_repo.dart';
import 'package:gpa_cal/util/errors.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static final log = Log("HomeBloc");
  static final HomeRepo _homeRepo = new HomeRepo();

  HomeBloc(BuildContext context) : super(HomeState.initialState) {
    this._initialize();
  }

  Future<void> _initialize() async {
    try {
      UserResultModel userResultModel = await _homeRepo.firstInterfaceCheck();
      add(HomeInterfaceEvent(userResultModel));
    } on CacheNotPresentError {
      await Future.delayed(Duration(seconds: 2));
      add(FirstInterfaceEvent(true));
    } on CacheError {
      add(ErrorEvent('Stroage Limit Exceed!'));
    } catch (e) {
      add(ErrorEvent('Unexpected Error!'));
    }
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    switch (event.runtimeType) {
      case ErrorEvent:
        final error = (event as ErrorEvent).error;
        log.e('Error: $error');
        yield state.clone(error: "");
        yield state.clone(error: error, loading: false);
        break;
      case FirstInterfaceEvent:
        yield state.clone(loading: true);
        final cacheNotPresent = (event as FirstInterfaceEvent).cacheNotPresent;
        log.e('First Interface Event');
        yield state.clone(cacheNotPresent: cacheNotPresent, loading: false);
        break;
      case HomeInterfaceEvent:
        yield state.clone(loading: true);
        final userResultModel = (event as HomeInterfaceEvent).userResultModel;
        log.e('Home Interface Event');
        yield state.clone(userResultModel: userResultModel, loading: false);
        break;
      case DeleteSemesterEvent:
        yield state.clone(loading: true);
        final deleteSemester = (event as DeleteSemesterEvent).deleteSemester;
        await _homeRepo.deleteSemester(deleteSemester);
        log.e('Delete Semester Event called');
        yield state.clone(deleteSemester: deleteSemester, loading: false);
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
