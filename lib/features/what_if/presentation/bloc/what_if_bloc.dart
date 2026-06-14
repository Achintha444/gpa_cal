import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/constants/gpa_tables.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/features/what_if/presentation/bloc/what_if_event.dart';
import 'package:gpa_cal/features/what_if/presentation/bloc/what_if_state.dart';

/// Manages the state of the What-If Calculator screen.
///
/// On [WhatIfInitialized], loads the user's current CGPA and GPA scale from
/// the repositories. On any input change ([TargetCgpaChanged],
/// [NumCoursesChanged], [CreditsPerCourseChanged]), recalculates the required
/// average grade point and maps it to the nearest grade string on the chosen
/// scale.
///
/// Calculation formula:
/// ```
/// requiredGradePoint = (targetCgpa × (currentTotalCredit + newCredits)
///                       − currentTotalResult) / newCredits
/// ```
/// If [requiredGradePoint] exceeds the scale maximum, the status becomes
/// [WhatIfStatus.impossible].
class WhatIfBloc extends Bloc<WhatIfEvent, WhatIfState> {
  /// Logger for this BLoC.
  static final Log _log = Log('WhatIfBloc');

  /// Repository for fetching semester data and cumulative totals.
  final SemesterRepository _semesterRepository;

  /// Repository for fetching the user's GPA scale preference.
  final UserDetailsRepository _userDetailsRepository;

  /// Creates a [WhatIfBloc] with the required repositories.
  WhatIfBloc({
    required SemesterRepository semesterRepository,
    required UserDetailsRepository userDetailsRepository,
  })  : _semesterRepository = semesterRepository,
        _userDetailsRepository = userDetailsRepository,
        super(const WhatIfState()) {
    on<WhatIfInitialized>(_onWhatIfInitialized);
    on<TargetCgpaChanged>(_onTargetCgpaChanged);
    on<NumCoursesChanged>(_onNumCoursesChanged);
    on<CreditsPerCourseChanged>(_onCreditsPerCourseChanged);
  }

  /// Handles [WhatIfInitialized] — loads the user's current academic data.
  ///
  /// Emits [WhatIfStatus.loading] then [WhatIfStatus.ready] once the
  /// current CGPA, totals, and GPA type are loaded, or [WhatIfStatus.error]
  /// on failure.
  Future<void> _onWhatIfInitialized(
    WhatIfInitialized event,
    Emitter<WhatIfState> emit,
  ) async {
    emit(state.copyWith(status: WhatIfStatus.loading));

    try {
      final UserResult userResult = await _semesterRepository.getUserResult();
      final UserDetails userDetails =
          await _userDetailsRepository.getUserDetails();

      _log.d(
        'WhatIfInitialized: CGPA=${userResult.cgpa}, '
        'totalCredit=${userResult.cumulativeCredit}, '
        'gpaType=${userDetails.gpaType}',
      );

      emit(state.copyWith(
        status: WhatIfStatus.ready,
        currentCgpa: userResult.cgpa,
        currentTotalResult: userResult.cumulativeResult,
        currentTotalCredit: userResult.cumulativeCredit,
        gpaType: userDetails.gpaType,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('WhatIfInitialized failed: $e');
      emit(state.copyWith(
        status: WhatIfStatus.error,
        errorMessage: 'Failed to load your data. Please try again.',
      ));
    }
  }

  /// Handles [TargetCgpaChanged] — updates target and recalculates.
  Future<void> _onTargetCgpaChanged(
    TargetCgpaChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    final WhatIfState next = state.copyWith(targetCgpa: event.targetCgpa);
    emit(_calculate(next));
  }

  /// Handles [NumCoursesChanged] — updates course count and recalculates.
  Future<void> _onNumCoursesChanged(
    NumCoursesChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    final WhatIfState next = state.copyWith(numCourses: event.numCourses);
    emit(_calculate(next));
  }

  /// Handles [CreditsPerCourseChanged] — updates credits and recalculates.
  Future<void> _onCreditsPerCourseChanged(
    CreditsPerCourseChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    final WhatIfState next =
        state.copyWith(creditsPerCourse: event.creditsPerCourse);
    emit(_calculate(next));
  }

  /// Calculates the required average grade point from the current [state] and
  /// returns an updated state with a [WhatIfResult] or [WhatIfStatus.impossible].
  ///
  /// If the target CGPA is 0 or new credits are 0, returns [WhatIfStatus.ready]
  /// without a result.
  WhatIfState _calculate(WhatIfState next) {
    final double targetCgpa = next.targetCgpa;
    final double newCredits = next.newCredits;

    // No target entered yet.
    if (targetCgpa <= 0.0 || newCredits <= 0.0) {
      return next.copyWith(status: WhatIfStatus.ready, clearResult: true);
    }

    final double requiredTotalResult =
        targetCgpa * (next.currentTotalCredit + newCredits);
    final double requiredNewResult =
        requiredTotalResult - next.currentTotalResult;
    final double requiredGradePoint = requiredNewResult / newCredits;

    final double maxGpa = next.gpaType == 1 ? 4.2 : 4.0;

    _log.d(
      '_calculate: targetCgpa=$targetCgpa, newCredits=$newCredits, '
      'requiredGradePoint=$requiredGradePoint',
    );

    if (requiredGradePoint > maxGpa) {
      return next.copyWith(
        status: WhatIfStatus.impossible,
        result: WhatIfResult(
          requiredGradePoint: requiredGradePoint,
          requiredGradeLabel: '',
          isAchievable: false,
        ),
      );
    }

    if (requiredGradePoint < 0.0) {
      // Target already met — any grade would suffice.
      final String topGrade = next.gpaType == 1 ? 'A+' : 'A+';
      return next.copyWith(
        status: WhatIfStatus.calculated,
        result: WhatIfResult(
          requiredGradePoint: 0.0,
          requiredGradeLabel: topGrade,
          isAchievable: true,
        ),
      );
    }

    // Map to nearest grade.
    final String gradeLabel = _nearestGrade(requiredGradePoint, next.gpaType);
    return next.copyWith(
      status: WhatIfStatus.calculated,
      result: WhatIfResult(
        requiredGradePoint: double.parse(
          requiredGradePoint.toStringAsPrecision(3),
        ),
        requiredGradeLabel: gradeLabel,
        isAchievable: true,
      ),
    );
  }

  /// Returns the grade string whose point value is closest to [required] from
  /// above (i.e., the minimum grade that meets or exceeds [required]).
  ///
  /// Falls back to the lowest grade if [required] is lower than all mapped
  /// values.
  String _nearestGrade(double required, int gpaType) {
    final Map<String, double> scale = GpaTables.scaleFor(gpaType);

    // Build a sorted list of (grade, point) pairs by descending point value.
    final List<MapEntry<String, double>> sorted = scale.entries.toList()
      ..sort((MapEntry<String, double> a, MapEntry<String, double> b) =>
          b.value.compareTo(a.value));

    // Find the lowest grade whose point value is >= required.
    String? match;
    for (final MapEntry<String, double> entry in sorted) {
      if (entry.value >= required) {
        match = entry.key;
      } else {
        break;
      }
    }

    return match ?? sorted.last.key;
  }
}
