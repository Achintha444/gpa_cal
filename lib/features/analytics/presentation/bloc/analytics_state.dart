import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_result.dart';

/// The loading status for the analytics screen.
enum AnalyticsStatus {
  /// The initial state before any data has been requested.
  initial,

  /// Data is currently being fetched.
  loading,

  /// Data loaded successfully with at least 2 semesters for analytics.
  success,

  /// Data loaded but fewer than 2 semesters exist — analytics cannot be shown.
  insufficientData,

  /// An error occurred during data loading.
  error,
}

/// The state for [AnalyticsBloc].
///
/// Holds the loaded [UserResult], the user's GPA scale type, and any error
/// message. Computed analytics metrics are exposed as getters to keep state
/// data minimal and derivation in one place.
class AnalyticsState extends Equatable {
  /// The current loading status.
  final AnalyticsStatus status;

  /// The cumulative user result including all semesters. Null until loaded.
  final UserResult? userResult;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates an [AnalyticsState].
  const AnalyticsState({
    this.status = AnalyticsStatus.initial,
    this.userResult,
    this.gpaType = 0,
    this.errorMessage = '',
  });

  // ---------------------------------------------------------------------------
  // Computed analytics getters
  // ---------------------------------------------------------------------------

  /// Returns the semester with the highest SGPA, or `null` if no data.
  Semester? get bestSemester {
    final List<Semester>? semesters = userResult?.semesters;
    if (semesters == null || semesters.isEmpty) return null;
    return semesters.reduce(
      (Semester a, Semester b) => a.sgpa >= b.sgpa ? a : b,
    );
  }

  /// Returns the semester with the lowest SGPA, or `null` if no data.
  Semester? get worstSemester {
    final List<Semester>? semesters = userResult?.semesters;
    if (semesters == null || semesters.isEmpty) return null;
    return semesters.reduce(
      (Semester a, Semester b) => a.sgpa <= b.sgpa ? a : b,
    );
  }

  /// Returns the mean SGPA across all semesters, or `0.0` if no data.
  double get averageSgpa {
    final List<Semester>? semesters = userResult?.semesters;
    if (semesters == null || semesters.isEmpty) return 0.0;
    final double total = semesters.fold(
      0.0,
      (double sum, Semester s) => sum + s.sgpa,
    );
    return double.parse((total / semesters.length).toStringAsPrecision(3));
  }

  /// Returns the total accumulated credit hours across all semesters.
  int get totalCredits {
    return (userResult?.cumulativeCredit ?? 0.0).toInt();
  }

  /// Returns the average credit hours per semester, or `0.0` if no data.
  double get averageCreditsPerSemester {
    final List<Semester>? semesters = userResult?.semesters;
    if (semesters == null || semesters.isEmpty) return 0.0;
    final double total = userResult?.cumulativeCredit ?? 0.0;
    return double.parse((total / semesters.length).toStringAsPrecision(3));
  }

  @override
  List<Object?> get props => [status, userResult, gpaType, errorMessage];

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Deep-copies [userResult] through its own [copyWith] to prevent
  /// shared-reference mutations between states.
  AnalyticsState copyWith({
    AnalyticsStatus? status,
    UserResult? userResult,
    int? gpaType,
    String? errorMessage,
  }) {
    return AnalyticsState(
      status: status ?? this.status,
      userResult: userResult ?? this.userResult,
      gpaType: gpaType ?? this.gpaType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
