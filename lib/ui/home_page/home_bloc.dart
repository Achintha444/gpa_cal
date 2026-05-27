import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:gpa_cal/util/log.dart';
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
    on<ErrorEvent>(_onErrorEvent);
    on<FirstInterfaceEvent>(_onFirstInterfaceEvent);
    on<HomeInterfaceEvent>(_onHomeInterfaceEvent);
    on<DeleteSemesterEvent>(_onDeleteSemesterEvent);
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

  void _onErrorEvent(ErrorEvent event, Emitter<HomeState> emit) {
    log.e('Error: ${event.error}');
    emit(state.clone(error: ""));
    emit(state.clone(error: event.error, loading: false));
  }

  void _onFirstInterfaceEvent(FirstInterfaceEvent event, Emitter<HomeState> emit) {
    emit(state.clone(loading: true));
    log.e('First Interface Event');
    emit(state.clone(cacheNotPresent: event.cacheNotPresent, loading: false));
  }

  void _onHomeInterfaceEvent(HomeInterfaceEvent event, Emitter<HomeState> emit) {
    emit(state.clone(loading: true));
    log.e('Home Interface Event');
    emit(state.clone(userResultModel: event.userResultModel, loading: false));
  }

  Future<void> _onDeleteSemesterEvent(DeleteSemesterEvent event, Emitter<HomeState> emit) async {
    emit(state.clone(loading: true));
    await _homeRepo.deleteSemester(event.deleteSemester);
    log.e('Delete Semester Event called');
    emit(state.clone(deleteSemester: event.deleteSemester, loading: false));
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
