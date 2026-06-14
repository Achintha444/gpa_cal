import 'package:gpa_cal/core/constants/gpa_tables.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// Provides static GPA calculation utilities for both supported grading scales.
///
/// All calculation logic lives here in the domain utility layer — never in
/// widgets, BLoCs, or repositories directly. Repositories call these methods
/// and return the results as part of domain entities.
///
/// Supported scales:
/// - `gpaType = 0` → 4.0 scale
/// - `gpaType = 1` → 4.2 scale
///
/// Usage:
/// ```dart
/// final double sgpa = GpaCalculator.calculateSgpa(
///   subjects: subjects,
///   gpaType: 0,
/// );
/// final double cgpa = GpaCalculator.calculateCgpa(
///   totalResult: 45.3,
///   totalCredit: 15.0,
/// );
/// ```
abstract final class GpaCalculator {
  /// Calculates the Semester GPA (SGPA) for the given [subjects].
  ///
  /// Formula: `SGPA = sum(grade_point * credit) / sum(credit)`
  ///
  /// Returns `0.0` when total credits are zero to avoid division by zero.
  /// The result is rounded to 3 significant figures.
  ///
  /// Parameters:
  /// - [subjects] — the list of subjects in the semester.
  /// - [gpaType] — the grading scale: `0` for 4.0, `1` for 4.2.
  static double calculateSgpa({
    required List<Subject> subjects,
    required int gpaType,
  }) {
    double totalCredit = 0.0;
    double totalResult = 0.0;

    final Map<String, double> scale = GpaTables.scaleFor(gpaType);

    for (final Subject subject in subjects) {
      final double credit = subject.credit;
      final double gradePoint = scale[subject.grade] ?? 0.0;
      totalCredit += credit;
      totalResult += gradePoint * credit;
    }

    if (totalCredit == 0.0) {
      return 0.0;
    }

    return double.parse((totalResult / totalCredit).toStringAsPrecision(3));
  }

  /// Calculates the Cumulative GPA (CGPA) from pre-aggregated totals.
  ///
  /// Formula: `CGPA = totalResult / totalCredit`
  ///
  /// Returns `0.0` when [totalCredit] is zero to avoid division by zero.
  /// The result is rounded to 3 significant figures.
  ///
  /// Parameters:
  /// - [totalResult] — the sum of (grade_point * credit) across all semesters.
  /// - [totalCredit] — the total credit hours across all semesters.
  static double calculateCgpa({
    required double totalResult,
    required double totalCredit,
  }) {
    if (totalCredit == 0.0) {
      return 0.0;
    }

    return double.parse((totalResult / totalCredit).toStringAsPrecision(3));
  }

  /// Returns the grade point value for the given [grade] in the specified [gpaType] scale.
  ///
  /// Returns `0.0` if the grade is not found in the scale.
  ///
  /// Parameters:
  /// - [grade] — the letter grade string (e.g., "A+", "B-").
  /// - [gpaType] — the grading scale: `0` for 4.0, `1` for 4.2.
  static double gradePointFor(String grade, int gpaType) {
    return GpaTables.scaleFor(gpaType)[grade] ?? 0.0;
  }
}
