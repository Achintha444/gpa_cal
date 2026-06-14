import 'package:equatable/equatable.dart';

/// Base class for all [SemesterDetailBloc] events.
sealed class SemesterDetailEvent extends Equatable {
  /// Creates a [SemesterDetailEvent].
  const SemesterDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the semester detail screen is opened.
///
/// Provides the [hash] of the semester to display. The bloc finds the
/// matching [Semester] from the [UserResult] returned by the repository.
final class SemesterDetailRequested extends SemesterDetailEvent {
  /// The unique hash identifier of the semester to load.
  final int hash;

  /// Creates a [SemesterDetailRequested] event.
  const SemesterDetailRequested(this.hash);

  @override
  List<Object?> get props => [hash];
}
