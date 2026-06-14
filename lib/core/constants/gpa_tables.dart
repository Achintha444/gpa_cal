/// Provides GPA conversion tables and grade lists for both supported grading scales.
///
/// Two grading scales are supported:
/// - `gpaType = 0` → 4.0 scale (standard, used by most universities)
/// - `gpaType = 1` → 4.2 scale (extended, where A+ = 4.2)
///
/// Usage:
/// ```dart
/// final double point = GpaTables.scale40['A+'] ?? 0.0;
/// final List<String> grades = GpaTables.gradesFor(gpaType);
/// ```
abstract final class GpaTables {
  // ---------------------------------------------------------------------------
  // 4.0 Scale
  // ---------------------------------------------------------------------------

  /// Grade-to-point mapping for the 4.0 grading scale (gpaType = 0).
  ///
  /// A+ and A both map to 4.0. Unknown grades default to 0.0 via null-coalescing.
  static const Map<String, double> scale40 = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'E': 0.0,
    'I-we': 0.0,
    'F': 0.0,
  };

  /// Ordered list of valid grade strings for the 4.0 scale.
  ///
  /// Ordered from highest to lowest for display in grade pickers.
  static const List<String> grades40 = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'E',
    'I-we',
    'F',
  ];

  // ---------------------------------------------------------------------------
  // 4.2 Scale
  // ---------------------------------------------------------------------------

  /// Grade-to-point mapping for the 4.2 grading scale (gpaType = 1).
  ///
  /// A+ maps to 4.2, making this scale more granular at the top.
  /// Note: C- maps to 1.5 (not 1.7) and D+ is not present in this scale.
  static const Map<String, double> scale42 = {
    'A+': 4.2,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.5,
    'D': 1.0,
    'I-we': 0.0,
    'F': 0.0,
  };

  /// Ordered list of valid grade strings for the 4.2 scale.
  ///
  /// Ordered from highest to lowest for display in grade pickers.
  static const List<String> grades42 = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D',
    'I-we',
    'F',
  ];

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the grade-to-point map for the given [gpaType].
  ///
  /// Returns [scale40] when [gpaType] is `0`, and [scale42] when [gpaType] is `1`.
  /// Defaults to [scale40] for any unrecognised value.
  static Map<String, double> scaleFor(int gpaType) {
    return gpaType == 1 ? scale42 : scale40;
  }

  /// Returns the ordered grade list for the given [gpaType].
  ///
  /// Returns [grades40] when [gpaType] is `0`, and [grades42] when [gpaType] is `1`.
  /// Defaults to [grades40] for any unrecognised value.
  static List<String> gradesFor(int gpaType) {
    return gpaType == 1 ? grades42 : grades40;
  }
}
