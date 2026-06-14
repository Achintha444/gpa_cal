import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// Base class for all [AddSemesterBloc] events.
sealed class AddSemesterEvent extends Equatable {
  /// Creates an [AddSemesterEvent].
  const AddSemesterEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the add-semester screen is first opened.
///
/// Provides the semester name and GPA type to initialise the BLoC state.
final class AddSemesterInitialized extends AddSemesterEvent {
  /// The display name for the new semester.
  final String name;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Creates an [AddSemesterInitialized] event.
  const AddSemesterInitialized({required this.name, required this.gpaType});

  @override
  List<Object?> get props => [name, gpaType];
}

/// Triggered when the user edits a course field.
///
/// The bloc replaces the subject at [index] and recalculates the SGPA.
final class CourseUpdated extends AddSemesterEvent {
  /// The zero-based index of the subject to update.
  final int index;

  /// The updated subject data.
  final Subject subject;

  /// Creates a [CourseUpdated] event.
  const CourseUpdated({required this.index, required this.subject});

  @override
  List<Object?> get props => [index, subject];
}

/// Triggered when the user taps "+ Add Another Course".
///
/// Appends a new default course (A+, 3.0 credits) to the subject list.
final class CourseAdded extends AddSemesterEvent {
  /// Creates a [CourseAdded] event.
  const CourseAdded();
}

/// Triggered when the user taps the delete icon on a course card.
///
/// If only one course remains, the bloc emits an error instead of deleting.
final class CourseDeleted extends AddSemesterEvent {
  /// The zero-based index of the subject to remove.
  final int index;

  /// Creates a [CourseDeleted] event.
  const CourseDeleted(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered when the user taps "Confirm" to save the semester.
///
/// The bloc assembles a [Semester] entity, persists it, and emits saved status.
final class SemesterConfirmed extends AddSemesterEvent {
  /// Creates a [SemesterConfirmed] event.
  const SemesterConfirmed();
}
