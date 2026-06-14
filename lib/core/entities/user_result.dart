import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/semester.dart';

/// Represents the user's cumulative academic result across all semesters.
///
/// This is the top-level aggregate returned by the semester repository.
/// It holds the CGPA along with the underlying semester data used to compute it.
class UserResult extends Equatable {
  /// The calculated Cumulative GPA across all semesters.
  final double cgpa;

  /// The sum of weighted grade points (grade_point * credit) across all semesters.
  final double cumulativeResult;

  /// The total credit hours accumulated across all semesters.
  final double cumulativeCredit;

  /// The list of all semesters recorded by the user.
  final List<Semester> semesters;

  /// Creates a [UserResult] with the given cumulative data.
  const UserResult({
    required this.cgpa,
    required this.cumulativeResult,
    required this.cumulativeCredit,
    required this.semesters,
  });

  @override
  List<Object?> get props => [cgpa, cumulativeResult, cumulativeCredit, semesters];

  /// Creates a copy of this [UserResult] with the given fields replaced.
  ///
  /// Deep-copies [semesters] to prevent shared-reference mutations between states.
  UserResult copyWith({
    double? cgpa,
    double? cumulativeResult,
    double? cumulativeCredit,
    List<Semester>? semesters,
  }) {
    return UserResult(
      cgpa: cgpa ?? this.cgpa,
      cumulativeResult: cumulativeResult ?? this.cumulativeResult,
      cumulativeCredit: cumulativeCredit ?? this.cumulativeCredit,
      semesters:
          semesters != null ? List.of(semesters) : List.of(this.semesters),
    );
  }
}
