import 'package:hive/hive.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/features/semester/data/models/subject_model.dart';

part 'semester_model.g.dart';

/// Hive-persisted model for a single academic semester.
///
/// Maps to and from the domain [Semester] entity in the repository layer.
/// Contains a list of [SubjectModel] objects rather than domain [Subject] entities.
/// This model is used exclusively within the data layer.
@HiveType(typeId: 0)
class SemesterModel extends HiveObject {
  /// Creates an empty [SemesterModel].
  ///
  /// Fields are populated via Hive deserialization or [fromDomain].
  SemesterModel();
  /// Unique identifier for this semester, matching [Semester.hash].
  @HiveField(0)
  late int hash;

  /// The display name for this semester.
  @HiveField(1)
  late String name;

  /// The calculated Semester GPA.
  @HiveField(2)
  late double sgpa;

  /// The weighted sum of (grade_point * credit) for all subjects.
  @HiveField(3)
  late double totalResult;

  /// The sum of all credit hours for subjects in this semester.
  @HiveField(4)
  late double totalCredit;

  /// The list of subjects stored as Hive models.
  @HiveField(5)
  late List<SubjectModel> subjectList;

  /// Converts this Hive model to a domain [Semester] entity.
  Semester toDomain() {
    return Semester(
      hash: hash,
      name: name,
      sgpa: sgpa,
      totalResult: totalResult,
      totalCredit: totalCredit,
      subjectList: subjectList.map((SubjectModel s) => s.toDomain()).toList(),
    );
  }

  /// Creates a [SemesterModel] from a domain [Semester] entity.
  factory SemesterModel.fromDomain(Semester semester) {
    return SemesterModel()
      ..hash = semester.hash
      ..name = semester.name
      ..sgpa = semester.sgpa
      ..totalResult = semester.totalResult
      ..totalCredit = semester.totalCredit
      ..subjectList = semester.subjectList
          .map((s) => SubjectModel.fromDomain(s))
          .toList();
  }
}
