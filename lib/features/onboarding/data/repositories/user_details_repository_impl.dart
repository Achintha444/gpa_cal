import 'package:hive/hive.dart';
import 'package:gpa_cal/core/constants/cache_keys.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/errors/failures.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/onboarding/data/models/user_details_model.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/data/models/user_result_model.dart';

/// Concrete implementation of [UserDetailsRepository] backed by Hive.
///
/// Reads and writes a single [UserDetailsModel] record keyed by
/// [CacheKeys.userDetails] in the [CacheKeys.hiveUserDetailsBox].
/// Also clears the user result box when [clearAll] is called.
class UserDetailsRepositoryImpl implements UserDetailsRepository {
  /// Logger for this repository.
  static final Log _log = Log('UserDetailsRepositoryImpl');

  /// The Hive box used to store the [UserDetailsModel].
  Box<UserDetailsModel> get _detailsBox =>
      Hive.box<UserDetailsModel>(CacheKeys.hiveUserDetailsBox);

  @override
  Future<UserDetails> getUserDetails() async {
    try {
      final UserDetailsModel? model =
          _detailsBox.get(CacheKeys.userDetails);

      if (model == null) {
        throw const CacheNotFoundFailure('No user details found.');
      }

      return model.toDomain();
    } catch (e) {
      _log.e('getUserDetails failed: $e');
      if (e is CacheNotFoundFailure) rethrow;
      throw CacheFailure('Failed to load user details: $e');
    }
  }

  @override
  Future<void> saveUserDetails(UserDetails userDetails) async {
    try {
      await _detailsBox.put(
        CacheKeys.userDetails,
        UserDetailsModel.fromDomain(userDetails),
      );
      _log.d('saveUserDetails: saved for "${userDetails.name}"');
    } catch (e) {
      _log.e('saveUserDetails failed: $e');
      throw CacheFailure('Failed to save user details: $e');
    }
  }

  @override
  Future<bool> hasUserDetails() async {
    try {
      return _detailsBox.containsKey(CacheKeys.userDetails);
    } catch (e) {
      _log.e('hasUserDetails check failed: $e');
      return false;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _detailsBox.clear();
      // Also clear the user result box to remove all semester data.
      final Box<UserResultModel> resultBox =
          Hive.box<UserResultModel>(CacheKeys.hiveUserResultBox);
      await resultBox.clear();
      _log.d('clearAll: all user data cleared');
    } catch (e) {
      _log.e('clearAll failed: $e');
      throw CacheFailure('Failed to clear all data: $e');
    }
  }
}
