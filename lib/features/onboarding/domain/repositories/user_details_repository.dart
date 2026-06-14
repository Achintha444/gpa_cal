import 'package:gpa_cal/core/entities/user_details.dart';

/// Contract for user profile data operations.
///
/// Implemented by [UserDetailsRepositoryImpl] in the data layer.
/// Used by the onboarding and settings features to read and write
/// the user's name, university, and GPA scale preference.
abstract class UserDetailsRepository {
  /// Retrieves the stored [UserDetails] for the current user.
  ///
  /// Throws [CacheNotFoundFailure] if no user details have been saved yet.
  /// Throws [CacheFailure] if the local data store is inaccessible.
  Future<UserDetails> getUserDetails();

  /// Persists the given [userDetails], replacing any existing record.
  ///
  /// Throws [CacheFailure] on storage failure.
  Future<void> saveUserDetails(UserDetails userDetails);

  /// Returns `true` if user details have been saved (i.e., onboarding is complete).
  Future<bool> hasUserDetails();

  /// Deletes all user data including details and semester results.
  ///
  /// Used for account reset / sign-out flows.
  /// Throws [CacheFailure] on storage failure.
  Future<void> clearAll();
}
