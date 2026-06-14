import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_result.dart';

/// Contract for all semester data operations.
///
/// Implemented by [SemesterRepositoryImpl] in the data layer.
/// The domain layer depends on this interface; the data layer depends on nothing
/// in the domain layer (dependency inversion).
///
/// All operations are async as they access local Hive storage.
abstract class SemesterRepository {
  /// Retrieves the cumulative user result, including all persisted semesters.
  ///
  /// Returns a [UserResult] with an empty semester list if no data exists yet.
  /// Throws [CacheFailure] if the local data store is inaccessible.
  Future<UserResult> getUserResult();

  /// Adds a new [semester] and recalculates the CGPA.
  ///
  /// Returns the updated [UserResult] after the semester is persisted.
  /// Throws [CacheFailure] on storage failure.
  Future<UserResult> addSemester(Semester semester);

  /// Replaces the existing semester with the same [Semester.hash] and recalculates CGPA.
  ///
  /// Throws [CacheFailure] if the semester is not found or the update fails.
  Future<void> editSemester(Semester semester);

  /// Removes the semester identified by [semesterHash] and recalculates CGPA.
  ///
  /// If this was the last semester, clears the result box entirely.
  /// Throws [CacheFailure] on storage failure.
  Future<void> deleteSemester(int semesterHash);

  /// Returns `true` if any semester data exists in local storage.
  Future<bool> hasData();
}
