import 'package:equatable/equatable.dart';

/// The calculation status for the what-if calculator.
enum WhatIfStatus {
  /// The initial state before data has been loaded.
  initial,

  /// Data is being loaded from repositories.
  loading,

  /// The user has not yet entered a valid target CGPA — showing prompt.
  ready,

  /// The required average has been calculated successfully.
  calculated,

  /// The target CGPA has already been achieved with the current standing.
  alreadyAchieved,

  /// The target is mathematically impossible with the given remaining credits.
  impossible,

  /// An error occurred during data loading.
  error,
}

/// Holds the result of a what-if calculation.
///
/// Returned when the calculation produces a definitive outcome — contains the
/// required average grade point, the grade label, and whether it is achievable.
class WhatIfResult extends Equatable {
  /// The required average grade point value to achieve the target CGPA.
  final double requiredGradePoint;

  /// The nearest grade string matching [requiredGradePoint] on the chosen scale.
  ///
  /// Empty when [isAchievable] is `false`.
  final String requiredGradeLabel;

  /// Whether the target CGPA is achievable with the given remaining credits.
  final bool isAchievable;

  /// Creates a [WhatIfResult].
  const WhatIfResult({
    required this.requiredGradePoint,
    required this.requiredGradeLabel,
    required this.isAchievable,
  });

  @override
  List<Object?> get props => [
        requiredGradePoint,
        requiredGradeLabel,
        isAchievable,
      ];
}

/// The state for [WhatIfBloc].
///
/// Holds the user's current academic standing, the what-if planning inputs,
/// and the computed [WhatIfResult]. All mutable fields are replaced via
/// [copyWith].
class WhatIfState extends Equatable {
  /// The current calculation status.
  final WhatIfStatus status;

  /// The user's current CGPA as stored in the repository.
  final double currentCgpa;

  /// The sum of weighted grade points across all existing semesters.
  final double currentTotalResult;

  /// The total credit hours across all existing semesters.
  final double currentTotalCredit;

  /// The user's GPA scale type: `0` for 4.0, `1` for 4.2.
  final int gpaType;

  /// The target CGPA the user wants to achieve.
  final double targetCgpa;

  /// The number of remaining semesters (1–20).
  ///
  /// Informational context displayed in the result card. Does not affect
  /// the calculation math.
  final int remainingSemesters;

  /// The total credit hours across all remaining semesters (1–200).
  ///
  /// This is the credit value directly used in the calculation formula.
  final double totalRemainingCredits;

  /// The result of the last calculation. Null when not yet calculated.
  final WhatIfResult? result;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates a [WhatIfState] with default values for all optional fields.
  const WhatIfState({
    this.status = WhatIfStatus.initial,
    this.currentCgpa = 0.0,
    this.currentTotalResult = 0.0,
    this.currentTotalCredit = 0.0,
    this.gpaType = 0,
    this.targetCgpa = 0.0,
    this.remainingSemesters = 1,
    this.totalRemainingCredits = 12.0,
    this.result,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        status,
        currentCgpa,
        currentTotalResult,
        currentTotalCredit,
        gpaType,
        targetCgpa,
        remainingSemesters,
        totalRemainingCredits,
        result,
        errorMessage,
      ];

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Pass [clearResult] as `true` to set [result] to `null` regardless of
  /// whether a new [result] value is provided.
  WhatIfState copyWith({
    WhatIfStatus? status,
    double? currentCgpa,
    double? currentTotalResult,
    double? currentTotalCredit,
    int? gpaType,
    double? targetCgpa,
    int? remainingSemesters,
    double? totalRemainingCredits,
    WhatIfResult? result,
    bool clearResult = false,
    String? errorMessage,
  }) {
    return WhatIfState(
      status: status ?? this.status,
      currentCgpa: currentCgpa ?? this.currentCgpa,
      currentTotalResult: currentTotalResult ?? this.currentTotalResult,
      currentTotalCredit: currentTotalCredit ?? this.currentTotalCredit,
      gpaType: gpaType ?? this.gpaType,
      targetCgpa: targetCgpa ?? this.targetCgpa,
      remainingSemesters: remainingSemesters ?? this.remainingSemesters,
      totalRemainingCredits:
          totalRemainingCredits ?? this.totalRemainingCredits,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
