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

  /// The target is mathematically impossible within one semester.
  impossible,

  /// An error occurred during data loading.
  error,
}

/// Holds the result of a what-if calculation.
///
/// Returned when the calculation succeeds — contains the required average
/// grade string and whether the target is achievable.
class WhatIfResult extends Equatable {
  /// The required average grade point value.
  final double requiredGradePoint;

  /// The nearest grade string matching [requiredGradePoint] on the chosen scale.
  ///
  /// Empty when [isAchievable] is `false`.
  final String requiredGradeLabel;

  /// Whether the target is achievable within one semester at the given inputs.
  final bool isAchievable;

  /// Creates a [WhatIfResult].
  const WhatIfResult({
    required this.requiredGradePoint,
    required this.requiredGradeLabel,
    required this.isAchievable,
  });

  @override
  List<Object?> get props => [requiredGradePoint, requiredGradeLabel, isAchievable];
}

/// The state for [WhatIfBloc].
///
/// Holds the user's current academic standing, the what-if inputs, and
/// the computed [WhatIfResult]. All mutable fields are replaced via [copyWith].
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

  /// The number of courses in the hypothetical next semester (1–8).
  final int numCourses;

  /// The credits per course in the hypothetical next semester (0.5–10).
  final double creditsPerCourse;

  /// The result of the last calculation. Null when not yet calculated.
  final WhatIfResult? result;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates a [WhatIfState].
  const WhatIfState({
    this.status = WhatIfStatus.initial,
    this.currentCgpa = 0.0,
    this.currentTotalResult = 0.0,
    this.currentTotalCredit = 0.0,
    this.gpaType = 0,
    this.targetCgpa = 0.0,
    this.numCourses = 4,
    this.creditsPerCourse = 3.0,
    this.result,
    this.errorMessage = '',
  });

  /// The total credits for the hypothetical next semester.
  double get newCredits => numCourses * creditsPerCourse;

  @override
  List<Object?> get props => [
        status,
        currentCgpa,
        currentTotalResult,
        currentTotalCredit,
        gpaType,
        targetCgpa,
        numCourses,
        creditsPerCourse,
        result,
        errorMessage,
      ];

  /// Creates a copy of this state with the given fields replaced.
  WhatIfState copyWith({
    WhatIfStatus? status,
    double? currentCgpa,
    double? currentTotalResult,
    double? currentTotalCredit,
    int? gpaType,
    double? targetCgpa,
    int? numCourses,
    double? creditsPerCourse,
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
      numCourses: numCourses ?? this.numCourses,
      creditsPerCourse: creditsPerCourse ?? this.creditsPerCourse,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
