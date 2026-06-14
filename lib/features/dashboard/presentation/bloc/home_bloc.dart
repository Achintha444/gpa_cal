import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_event.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_state.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Manages the state of the home dashboard screen.
///
/// Loads the user's [UserResult] (semesters + CGPA) and [UserDetails]
/// (name, university, GPA scale) on [HomeDataRequested]. Handles semester
/// deletion via [SemesterDeleted] by delegating to [SemesterRepository] then
/// re-fetching updated data.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// Logger for this BLoC.
  static final Log _log = Log('HomeBloc');

  /// Repository for fetching and deleting semester data.
  final SemesterRepository _semesterRepository;

  /// Repository for fetching user profile details.
  final UserDetailsRepository _userDetailsRepository;

  /// Creates a [HomeBloc] with the required repositories.
  HomeBloc({
    required SemesterRepository semesterRepository,
    required UserDetailsRepository userDetailsRepository,
  })  : _semesterRepository = semesterRepository,
        _userDetailsRepository = userDetailsRepository,
        super(const HomeState()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<SemesterDeleted>(_onSemesterDeleted);
  }

  /// Handles [HomeDataRequested] — loads all user data from both repositories.
  ///
  /// Emits [HomeStatus.loading] immediately, then [HomeStatus.empty] when no
  /// semesters exist, [HomeStatus.success] with loaded data, or
  /// [HomeStatus.error] on failure.
  Future<void> _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final UserResult userResult = await _semesterRepository.getUserResult();
      final UserDetails userDetails =
          await _userDetailsRepository.getUserDetails();

      _log.d(
        'HomeDataRequested: loaded ${userResult.semesters.length} semesters, '
        'CGPA ${userResult.cgpa}',
      );

      if (userResult.semesters.isEmpty) {
        emit(state.copyWith(
          status: HomeStatus.empty,
          userResult: userResult,
          userDetails: userDetails,
          errorMessage: '',
        ));
      } else {
        emit(state.copyWith(
          status: HomeStatus.success,
          userResult: userResult,
          userDetails: userDetails,
          errorMessage: '',
        ));
      }
    } catch (e) {
      _log.e('HomeDataRequested failed: $e');
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to load your data. Please try again.',
      ));
    }
  }

  /// Handles [SemesterDeleted] — removes the semester and reloads data.
  ///
  /// Emits [HomeStatus.loading] while the deletion is in progress, then
  /// triggers a full reload via [_onHomeDataRequested].
  Future<void> _onSemesterDeleted(
    SemesterDeleted event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      await _semesterRepository.deleteSemester(event.hash);
      _log.d('SemesterDeleted: removed semester hash=${event.hash}');
    } catch (e) {
      _log.e('SemesterDeleted failed for hash=${event.hash}: $e');
      emit(state.copyWith(
        status: HomeStatus.error,
        errorMessage: 'Failed to delete semester. Please try again.',
      ));
      return;
    }

    // Reload data after successful deletion.
    await _onHomeDataRequested(const HomeDataRequested(), emit);
  }
}
