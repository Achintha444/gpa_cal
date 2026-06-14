import 'package:equatable/equatable.dart';

/// Represents a single academic course with its grade and credit weight.
///
/// Used across semester creation, editing, and GPA calculation flows.
/// This is an immutable domain entity shared across all features.
class Subject extends Equatable {
  /// The name of the course (e.g., "Data Structures").
  final String courseName;

  /// The letter grade received (e.g., "A+", "B-").
  final String grade;

  /// The credit hours assigned to this course.
  final double credit;

  /// Creates a [Subject] with the given course details.
  const Subject({
    required this.courseName,
    required this.grade,
    required this.credit,
  });

  @override
  List<Object?> get props => [courseName, grade, credit];

  /// Creates a copy of this [Subject] with the given fields replaced.
  Subject copyWith({
    String? courseName,
    String? grade,
    double? credit,
  }) {
    return Subject(
      courseName: courseName ?? this.courseName,
      grade: grade ?? this.grade,
      credit: credit ?? this.credit,
    );
  }
}
