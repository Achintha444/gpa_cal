import 'package:hive/hive.dart';
import 'package:gpa_cal/core/entities/subject.dart';

part 'subject_model.g.dart';

/// Hive-persisted model for a single academic subject (course).
///
/// Maps to and from the domain [Subject] entity in the repository layer.
/// This model is used exclusively within the data layer — the domain layer
/// only ever sees [Subject] instances.
@HiveType(typeId: 1)
class SubjectModel extends HiveObject {
  /// Creates an empty [SubjectModel].
  ///
  /// Fields are populated via Hive deserialization or [fromDomain].
  SubjectModel();
  /// The name of the course.
  @HiveField(0)
  late String courseName;

  /// The letter grade received (e.g., "A+", "B-").
  @HiveField(1)
  late String grade;

  /// The credit hours assigned to this course.
  @HiveField(2)
  late double credit;

  /// Converts this Hive model to a domain [Subject] entity.
  Subject toDomain() {
    return Subject(
      courseName: courseName,
      grade: grade,
      credit: credit,
    );
  }

  /// Creates a [SubjectModel] from a domain [Subject] entity.
  factory SubjectModel.fromDomain(Subject subject) {
    return SubjectModel()
      ..courseName = subject.courseName
      ..grade = subject.grade
      ..credit = subject.credit;
  }
}
