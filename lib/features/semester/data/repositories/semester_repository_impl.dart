import 'package:hive/hive.dart';
import 'package:gpa_cal/core/constants/cache_keys.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/errors/failures.dart';
import 'package:gpa_cal/core/utils/gpa_calculator.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/semester/data/models/semester_model.dart';
import 'package:gpa_cal/features/semester/data/models/user_result_model.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Concrete implementation of [SemesterRepository] backed by Hive.
///
/// All data transformation between [SemesterModel] / [UserResultModel] and
/// their corresponding domain entities ([Semester] / [UserResult]) happens here.
/// GPA recalculations are delegated to [GpaCalculator].
///
/// The repository reads and writes a single [UserResultModel] record keyed
/// by [CacheKeys.userResults] in the [CacheKeys.hiveUserResultBox].
class SemesterRepositoryImpl implements SemesterRepository {
  /// Logger for this repository.
  static final Log _log = Log('SemesterRepositoryImpl');

  /// The Hive box used to store the [UserResultModel].
  Box<UserResultModel> get _resultBox =>
      Hive.box<UserResultModel>(CacheKeys.hiveUserResultBox);

  @override
  Future<UserResult> getUserResult() async {
    try {
      final UserResultModel? model =
          _resultBox.get(CacheKeys.userResults);

      if (model == null) {
        return const UserResult(
          cgpa: 0.0,
          cumulativeResult: 0.0,
          cumulativeCredit: 0.0,
          semesters: [],
        );
      }

      return model.toDomain();
    } catch (e) {
      _log.e('getUserResult failed: $e');
      throw CacheFailure('Failed to load user result: $e');
    }
  }

  @override
  Future<UserResult> addSemester(Semester semester) async {
    try {
      final UserResult current = await getUserResult();

      final List<Semester> updatedSemesters = List.of(current.semesters)
        ..add(semester);

      final double newCumulativeResult =
          current.cumulativeResult + semester.totalResult;
      final double newCumulativeCredit =
          current.cumulativeCredit + semester.totalCredit;

      final double newCgpa = GpaCalculator.calculateCgpa(
        totalResult: newCumulativeResult,
        totalCredit: newCumulativeCredit,
      );

      final UserResult updated = UserResult(
        cgpa: newCgpa,
        cumulativeResult: newCumulativeResult,
        cumulativeCredit: newCumulativeCredit,
        semesters: updatedSemesters,
      );

      await _resultBox.put(
        CacheKeys.userResults,
        UserResultModel.fromDomain(updated),
      );

      _log.d('addSemester: added "${semester.name}", CGPA now $newCgpa');
      return updated;
    } catch (e) {
      _log.e('addSemester failed: $e');
      throw CacheFailure('Failed to add semester: $e');
    }
  }

  @override
  Future<void> editSemester(Semester semester) async {
    try {
      final UserResult current = await getUserResult();

      final int index = current.semesters.indexWhere(
        (Semester s) => s.hash == semester.hash,
      );

      if (index == -1) {
        throw CacheNotFoundFailure(
          'Semester with hash ${semester.hash} not found.',
        );
      }

      final List<Semester> updatedSemesters = List.of(current.semesters);
      updatedSemesters[index] = semester;

      final double newCumulativeResult = updatedSemesters.fold(
        0.0,
        (double acc, Semester s) => acc + s.totalResult,
      );
      final double newCumulativeCredit = updatedSemesters.fold(
        0.0,
        (double acc, Semester s) => acc + s.totalCredit,
      );

      final double newCgpa = GpaCalculator.calculateCgpa(
        totalResult: newCumulativeResult,
        totalCredit: newCumulativeCredit,
      );

      final UserResult updated = UserResult(
        cgpa: newCgpa,
        cumulativeResult: newCumulativeResult,
        cumulativeCredit: newCumulativeCredit,
        semesters: updatedSemesters,
      );

      await _resultBox.put(
        CacheKeys.userResults,
        UserResultModel.fromDomain(updated),
      );

      _log.d('editSemester: updated "${semester.name}", CGPA now $newCgpa');
    } catch (e) {
      _log.e('editSemester failed: $e');
      if (e is CacheNotFoundFailure) rethrow;
      throw CacheFailure('Failed to edit semester: $e');
    }
  }

  @override
  Future<void> deleteSemester(int semesterHash) async {
    try {
      final UserResult current = await getUserResult();

      final List<Semester> updatedSemesters = current.semesters
          .where((Semester s) => s.hash != semesterHash)
          .toList();

      // If no semesters remain, clear the box entirely.
      if (updatedSemesters.isEmpty) {
        await _resultBox.delete(CacheKeys.userResults);
        _log.d('deleteSemester: last semester removed, result box cleared');
        return;
      }

      final double newCumulativeResult = updatedSemesters.fold(
        0.0,
        (double acc, Semester s) => acc + s.totalResult,
      );
      final double newCumulativeCredit = updatedSemesters.fold(
        0.0,
        (double acc, Semester s) => acc + s.totalCredit,
      );

      final double newCgpa = GpaCalculator.calculateCgpa(
        totalResult: newCumulativeResult,
        totalCredit: newCumulativeCredit,
      );

      final UserResult updated = UserResult(
        cgpa: newCgpa,
        cumulativeResult: newCumulativeResult,
        cumulativeCredit: newCumulativeCredit,
        semesters: updatedSemesters,
      );

      await _resultBox.put(
        CacheKeys.userResults,
        UserResultModel.fromDomain(updated),
      );

      _log.d('deleteSemester: removed hash $semesterHash, CGPA now $newCgpa');
    } catch (e) {
      _log.e('deleteSemester failed: $e');
      if (e is CacheFailure) rethrow;
      throw CacheFailure('Failed to delete semester: $e');
    }
  }

  @override
  Future<bool> hasData() async {
    try {
      return _resultBox.containsKey(CacheKeys.userResults);
    } catch (e) {
      _log.e('hasData check failed: $e');
      return false;
    }
  }
}
