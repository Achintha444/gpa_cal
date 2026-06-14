import 'package:hive/hive.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/features/semester/data/models/semester_model.dart';

part 'user_result_model.g.dart';

/// Hive-persisted model for the user's cumulative academic result.
///
/// Maps to and from the domain [UserResult] entity in the repository layer.
/// Stores a list of [SemesterModel] objects. This is the root persistence
/// record — a single instance is stored in the Hive box.
@HiveType(typeId: 3)
class UserResultModel extends HiveObject {
  /// Creates an empty [UserResultModel].
  ///
  /// Fields are populated via Hive deserialization or [fromDomain].
  UserResultModel();
  /// The calculated Cumulative GPA.
  @HiveField(0)
  late double cgpa;

  /// The sum of weighted grade points across all semesters.
  @HiveField(1)
  late double cumulativeResult;

  /// The total credit hours accumulated across all semesters.
  @HiveField(2)
  late double cumulativeCredit;

  /// The list of all semester records stored as Hive models.
  @HiveField(3)
  late List<SemesterModel> semesters;

  /// Converts this Hive model to a domain [UserResult] entity.
  UserResult toDomain() {
    return UserResult(
      cgpa: cgpa,
      cumulativeResult: cumulativeResult,
      cumulativeCredit: cumulativeCredit,
      semesters: semesters.map((SemesterModel s) => s.toDomain()).toList(),
    );
  }

  /// Creates a [UserResultModel] from a domain [UserResult] entity.
  factory UserResultModel.fromDomain(UserResult userResult) {
    return UserResultModel()
      ..cgpa = userResult.cgpa
      ..cumulativeResult = userResult.cumulativeResult
      ..cumulativeCredit = userResult.cumulativeCredit
      ..semesters = userResult.semesters
          .map((s) => SemesterModel.fromDomain(s))
          .toList();
  }
}
