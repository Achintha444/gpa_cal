import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// Represents a single academic semester with its subjects and calculated GPA.
///
/// The [hash] field is used as a unique identifier, generated from the
/// current timestamp at creation time via [DateTime.now().millisecondsSinceEpoch].
/// This entity is shared across home, add_semester, edit_semester, and analytics features.
class Semester extends Equatable {
  /// Unique identifier for this semester.
  ///
  /// Generated as [DateTime.now().millisecondsSinceEpoch] at creation.
  final int hash;

  /// The display name for this semester (e.g., "Semester 1").
  final String name;

  /// The calculated Semester GPA for this semester.
  final double sgpa;

  /// The weighted sum of (grade_point * credit) for all subjects in this semester.
  final double totalResult;

  /// The sum of all credit hours for subjects in this semester.
  final double totalCredit;

  /// The list of academic subjects in this semester.
  final List<Subject> subjectList;

  /// Creates a [Semester] with the given semester details.
  const Semester({
    required this.hash,
    required this.name,
    required this.sgpa,
    required this.totalResult,
    required this.totalCredit,
    required this.subjectList,
  });

  @override
  List<Object?> get props => [
        hash,
        name,
        sgpa,
        totalResult,
        totalCredit,
        subjectList,
      ];

  /// Creates a copy of this [Semester] with the given fields replaced.
  ///
  /// Deep-copies [subjectList] to prevent shared-reference mutations between states.
  Semester copyWith({
    int? hash,
    String? name,
    double? sgpa,
    double? totalResult,
    double? totalCredit,
    List<Subject>? subjectList,
  }) {
    return Semester(
      hash: hash ?? this.hash,
      name: name ?? this.name,
      sgpa: sgpa ?? this.sgpa,
      totalResult: totalResult ?? this.totalResult,
      totalCredit: totalCredit ?? this.totalCredit,
      subjectList:
          subjectList != null ? List.of(subjectList) : List.of(this.subjectList),
    );
  }
}
