/// Defines all Hive box names and cache key constants used across the app.
///
/// Centralising keys here prevents typo-driven bugs and makes key changes
/// a single-point edit.
///
/// Usage:
/// ```dart
/// final box = Hive.box<UserDetailsModel>(CacheKeys.hiveUserDetailsBox);
/// ```
abstract final class CacheKeys {
  /// Key used to store and retrieve the [UserDetails] record within its Hive box.
  static const String userDetails = 'user_details';

  /// Key used to store and retrieve the [UserResult] record within its Hive box.
  static const String userResults = 'user_results';

  /// Name of the Hive box used to persist [SemesterModel] objects.
  static const String hiveSemesterBox = 'semesters';

  /// Name of the Hive box used to persist the [UserDetailsModel] record.
  static const String hiveUserDetailsBox = 'user_details_box';

  /// Name of the Hive box used to persist the [UserResultModel] record.
  static const String hiveUserResultBox = 'user_result_box';
}
