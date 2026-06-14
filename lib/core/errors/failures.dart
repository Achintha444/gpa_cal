import 'package:equatable/equatable.dart';

/// Base class for all domain-level failures.
///
/// Subclasses represent specific failure categories that the presentation
/// layer can handle with targeted user feedback (e.g., snackbars, inline errors).
///
/// Usage:
/// ```dart
/// try {
///   // ...
/// } catch (e) {
///   throw CacheFailure('Unable to read semesters: $e');
/// }
/// ```
abstract class Failure extends Equatable {
  /// A human-readable message describing the failure.
  final String message;

  /// Creates a [Failure] with the given [message].
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Thrown when a local storage (Hive) operation fails.
///
/// Examples: box not open, write error, corrupt data.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure] with an optional [message].
  const CacheFailure([super.message = 'Failed to access local storage.']);
}

/// Thrown when the requested data does not exist in local storage.
///
/// Examples: box is empty, key not found.
class CacheNotFoundFailure extends Failure {
  /// Creates a [CacheNotFoundFailure] with an optional [message].
  const CacheNotFoundFailure([super.message = 'No data found in local storage.']);
}

/// Thrown when input data fails domain-level validation rules.
///
/// Examples: empty course name, zero credits, invalid GPA type.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with an optional [message].
  const ValidationFailure([super.message = 'The provided data is invalid.']);
}
