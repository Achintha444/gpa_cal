import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:gpa_cal/features/analytics/presentation/bloc/analytics_state.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Manages the state of the analytics screen.
///
/// Loads the [UserResult] and [UserDetails] on [AnalyticsDataRequested].
/// Emits [AnalyticsStatus.insufficientData] when fewer than 2 semesters
/// exist, since trends and comparisons require at least 2 data points.
/// Emits [AnalyticsStatus.success] when analytics can be displayed.
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  /// Logger for this BLoC.
  static final Log _log = Log('AnalyticsBloc');

  /// Repository for fetching semester data.
  final SemesterRepository _semesterRepository;

  /// Repository for fetching user profile details.
  final UserDetailsRepository _userDetailsRepository;

  /// Creates an [AnalyticsBloc] with the required repositories.
  AnalyticsBloc({
    required SemesterRepository semesterRepository,
    required UserDetailsRepository userDetailsRepository,
  })  : _semesterRepository = semesterRepository,
        _userDetailsRepository = userDetailsRepository,
        super(const AnalyticsState()) {
    on<AnalyticsDataRequested>(_onAnalyticsDataRequested);
  }

  /// Handles [AnalyticsDataRequested] — loads user data and computes analytics.
  ///
  /// Emits [AnalyticsStatus.loading] immediately, then:
  /// - [AnalyticsStatus.insufficientData] if fewer than 2 semesters exist.
  /// - [AnalyticsStatus.success] when analytics data is ready.
  /// - [AnalyticsStatus.error] on any repository failure.
  Future<void> _onAnalyticsDataRequested(
    AnalyticsDataRequested event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(state.copyWith(status: AnalyticsStatus.loading));

    try {
      final UserResult userResult = await _semesterRepository.getUserResult();
      final UserDetails userDetails =
          await _userDetailsRepository.getUserDetails();

      _log.d(
        'AnalyticsDataRequested: loaded ${userResult.semesters.length} '
        'semesters, CGPA=${userResult.cgpa}',
      );

      if (userResult.semesters.length < 2) {
        emit(state.copyWith(
          status: AnalyticsStatus.insufficientData,
          userResult: userResult,
          gpaType: userDetails.gpaType,
          errorMessage: '',
        ));
      } else {
        emit(state.copyWith(
          status: AnalyticsStatus.success,
          userResult: userResult,
          gpaType: userDetails.gpaType,
          errorMessage: '',
        ));
      }
    } catch (e) {
      _log.e('AnalyticsDataRequested failed: $e');
      emit(state.copyWith(
        status: AnalyticsStatus.error,
        errorMessage: 'Failed to load analytics. Please try again.',
      ));
    }
  }
}
