import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// Base class for all [EditSemesterBloc] events.
sealed class EditSemesterEvent extends Equatable {
  /// Creates an [EditSemesterEvent].
  const EditSemesterEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when the edit-semester screen opens with the semester to edit.
///
/// Provides the [hash] of the semester to display and the [gpaType] so the
/// form renders the correct grade chip set. The bloc loads the semester
/// identified by [hash] from the repository and populates the form state.
final class EditSemesterInitialized extends EditSemesterEvent {
  /// The unique hash of the semester to load for editing.
  final int hash;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Creates an [EditSemesterInitialized] event.
  const EditSemesterInitialized(this.hash, {this.gpaType = 0});

  @override
  List<Object?> get props => [hash, gpaType];
}

/// Triggered when the user edits the semester name field.
final class SemesterNameChanged extends EditSemesterEvent {
  /// The updated semester name.
  final String name;

  /// Creates a [SemesterNameChanged] event.
  const SemesterNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

/// Triggered when the user edits a course field.
///
/// The bloc replaces the subject at [index] and recalculates the SGPA.
final class CourseUpdated extends EditSemesterEvent {
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
final class CourseAdded extends EditSemesterEvent {
  /// Creates a [CourseAdded] event.
  const CourseAdded();
}

/// Triggered when the user taps the delete icon on a course card.
///
/// If only one course remains, the bloc emits an error instead of deleting.
final class CourseDeleted extends EditSemesterEvent {
  /// The zero-based index of the subject to remove.
  final int index;

  /// Creates a [CourseDeleted] event.
  const CourseDeleted(this.index);

  @override
  List<Object?> get props => [index];
}

/// Triggered when the user taps "Save Changes".
///
/// The bloc assembles an updated [Semester] entity and persists it via
/// [SemesterRepository.editSemester].
final class SemesterSaved extends EditSemesterEvent {
  /// Creates a [SemesterSaved] event.
  const SemesterSaved();
}

/// Triggered when the user confirms deletion of this semester.
///
/// The bloc calls [SemesterRepository.deleteSemester] with the current hash.
final class SemesterDeleteRequested extends EditSemesterEvent {
  /// Creates a [SemesterDeleteRequested] event.
  const SemesterDeleteRequested();
}
