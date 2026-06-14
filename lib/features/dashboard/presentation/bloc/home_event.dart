import 'package:equatable/equatable.dart';

/// Base class for all [HomeBloc] events.
sealed class HomeEvent extends Equatable {
  /// Creates a [HomeEvent].
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the home screen is loaded or refreshed.
///
/// The bloc responds by fetching the user's [UserResult] and [UserDetails].
final class HomeDataRequested extends HomeEvent {
  /// Creates a [HomeDataRequested] event.
  const HomeDataRequested();
}

/// Triggered when the user confirms deletion of a semester.
///
/// The bloc deletes the semester identified by [hash] and reloads the data.
final class SemesterDeleted extends HomeEvent {
  /// The unique hash identifier of the semester to delete.
  final int hash;

  /// Creates a [SemesterDeleted] event with the given [hash].
  const SemesterDeleted(this.hash);

  @override
  List<Object?> get props => [hash];
}
