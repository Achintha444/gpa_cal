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
/// On [WhatIfInitialized], loads the user's current CGPA, cumulative totals,
/// and GPA scale from the repositories. On any input change
/// ([TargetCgpaChanged], [RemainingSemestersChanged],
/// [TotalRemainingCreditsChanged]), recalculates the required average grade
/// point and maps it to the nearest grade string on the chosen scale.
///
/// Calculation formula:
/// ```
/// requiredGradePoint = (targetCgpa × (currentTotalCredit + totalRemainingCredits)
///                       − currentTotalResult) / totalRemainingCredits
/// ```
///
/// [remainingSemesters] is informational context only — it does not influence
/// the calculation math.
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
    on<RemainingSemestersChanged>(_onRemainingSemestersChanged);
    on<TotalRemainingCreditsChanged>(_onTotalRemainingCreditsChanged);
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

  /// Handles [TargetCgpaChanged] — parses, validates, then recalculates.
  ///
  /// Ignores empty or unparseable strings. Values outside 0.00–maxScale are
  /// discarded silently so in-progress typing (e.g. "4.") does not break UI.
  Future<void> _onTargetCgpaChanged(
    TargetCgpaChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    if (event.value.isEmpty) {
      emit(state.copyWith(
        targetCgpa: 0.0,
        status: WhatIfStatus.ready,
        clearResult: true,
      ));
      return;
    }

    final double? parsed = double.tryParse(event.value);
    if (parsed == null) return;

    final double maxGpa = state.gpaType == 1 ? 4.2 : 4.0;
    if (parsed < 0.0 || parsed > maxGpa) return;

    final WhatIfState next = state.copyWith(targetCgpa: parsed);
    emit(_calculate(next));
  }

  /// Handles [RemainingSemestersChanged] — updates state and recalculates.
  Future<void> _onRemainingSemestersChanged(
    RemainingSemestersChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    final WhatIfState next =
        state.copyWith(remainingSemesters: event.value.toInt());
    emit(_calculate(next));
  }

  /// Handles [TotalRemainingCreditsChanged] — updates total remaining credits
  /// and recalculates.
  ///
  /// [value] is always valid because it originates from [CreditStepper].
  Future<void> _onTotalRemainingCreditsChanged(
    TotalRemainingCreditsChanged event,
    Emitter<WhatIfState> emit,
  ) async {
    final WhatIfState next =
        state.copyWith(totalRemainingCredits: event.value);
    emit(_calculate(next));
  }

  /// Calculates the required average grade point from [next] and returns an
  /// updated state with the appropriate status and [WhatIfResult].
  ///
  /// Returns [WhatIfStatus.ready] (no result) when no target has been entered.
  /// Returns [WhatIfStatus.alreadyAchieved] when the target is already met.
  /// Returns [WhatIfStatus.impossible] when the required grade exceeds the scale.
  /// Returns [WhatIfStatus.calculated] on a valid, achievable result.
  WhatIfState _calculate(WhatIfState next) {
    final double targetCgpa = next.targetCgpa;
    final double totalRemainingCredits = next.totalRemainingCredits;

    // No target entered yet — show prompt.
    if (targetCgpa <= 0.0) {
      return next.copyWith(status: WhatIfStatus.ready, clearResult: true);
    }

    if (totalRemainingCredits <= 0.0) {
      return next.copyWith(status: WhatIfStatus.ready, clearResult: true);
    }

    final double requiredTotalResult =
        targetCgpa * (next.currentTotalCredit + totalRemainingCredits);
    final double requiredNewResult =
        requiredTotalResult - next.currentTotalResult;
    final double requiredGradePoint = requiredNewResult / totalRemainingCredits;

    final double maxGpa = next.gpaType == 1 ? 4.2 : 4.0;

    _log.d(
      '_calculate: targetCgpa=$targetCgpa, '
      'totalRemainingCredits=$totalRemainingCredits, '
      'requiredGradePoint=$requiredGradePoint',
    );

    // Target already achieved — no effort needed.
    if (requiredGradePoint <= 0.0) {
      return next.copyWith(
        status: WhatIfStatus.alreadyAchieved,
        result: const WhatIfResult(
          requiredGradePoint: 0.0,
          requiredGradeLabel: '',
          isAchievable: true,
        ),
      );
    }

    // Required grade point exceeds the scale maximum — impossible.
    if (requiredGradePoint > maxGpa) {
      return next.copyWith(
        status: WhatIfStatus.impossible,
        result: WhatIfResult(
          requiredGradePoint: double.parse(
            requiredGradePoint.toStringAsPrecision(3),
          ),
          requiredGradeLabel: '',
          isAchievable: false,
        ),
      );
    }

    // Map to the nearest grade on the chosen scale.
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

  /// Returns the grade label for the minimum grade that meets or exceeds
  /// [required] on the given [gpaType] scale.
  ///
  /// Iterates the scale sorted by descending point value and returns the
  /// last entry whose point is >= [required]. Falls back to the lowest grade
  /// if no entry matches (should not happen when [required] <= maxGpa).
  String _nearestGrade(double required, int gpaType) {
    final Map<String, double> scale = GpaTables.scaleFor(gpaType);

    final List<MapEntry<String, double>> sorted = scale.entries.toList()
      ..sort(
        (MapEntry<String, double> a, MapEntry<String, double> b) =>
            b.value.compareTo(a.value),
      );

    // Walk from highest to lowest; keep updating match while the entry still
    // satisfies the requirement. The last match is the minimum qualifying grade.
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
