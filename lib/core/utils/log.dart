import 'dart:developer' as developer;

/// A lightweight logging utility for tagged debug and error output.
///
/// Uses `dart:developer` under the hood so logs appear in the Flutter
/// DevTools console rather than stdout. Safe for production — the log
/// level controls filtering in DevTools.
///
/// Usage:
/// ```dart
/// final Log _log = Log('SemesterRepositoryImpl');
///
/// _log.d('Loaded ${semesters.length} semesters');
/// _log.e('Failed to open Hive box: $e');
/// ```
class Log {
  /// The tag used to identify the source of log messages in DevTools.
  final String tag;

  /// Creates a [Log] instance with the given [tag].
  const Log(this.tag);

  /// Logs a debug-level message.
  ///
  /// Use for informational messages during normal operation.
  void d(String message) {
    developer.log(message, name: tag);
  }

  /// Logs an error-level message.
  ///
  /// Use for failures, unexpected conditions, and caught exceptions.
  /// Maps to the `severe` log level (1000) in `dart:developer`.
  void e(String message) {
    developer.log(message, name: tag, level: 1000);
  }
}
