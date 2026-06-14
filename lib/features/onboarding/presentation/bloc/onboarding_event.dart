import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// Base class for all events dispatched to [OnboardingBloc].
sealed class OnboardingEvent extends Equatable {
  /// Creates an [OnboardingEvent].
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Emitted when the user updates the name field.
final class NameChanged extends OnboardingEvent {
  /// The new value entered in the name field.
  final String name;

  /// Creates a [NameChanged] event with the given [name].
  const NameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

/// Emitted when the user updates the university field.
final class UniversityChanged extends OnboardingEvent {
  /// The new value entered in the university field.
  final String university;

  /// Creates a [UniversityChanged] event with the given [university].
  const UniversityChanged(this.university);

  @override
  List<Object?> get props => [university];
}

/// Emitted when the user selects a different GPA scale.
final class GpaTypeChanged extends OnboardingEvent {
  /// The selected GPA type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Creates a [GpaTypeChanged] event with the given [gpaType].
  const GpaTypeChanged(this.gpaType);

  @override
  List<Object?> get props => [gpaType];
}

/// Emitted when the user taps "Continue" on the profile setup screen.
///
/// Triggers validation and persistence of the user's profile data.
final class ProfileSubmitted extends OnboardingEvent {
  /// Creates a [ProfileSubmitted] event.
  const ProfileSubmitted();
}

/// Emitted when the user taps "Finish Setup" on the first semester screen.
///
/// Creates a [Semester] entity from [semesterName] and [subjects], persists it,
/// and emits a success state so the UI can navigate to home.
final class FirstSemesterSubmitted extends OnboardingEvent {
  /// The display name for the user's first semester.
  final String semesterName;

  /// The list of courses entered for this semester.
  final List<Subject> subjects;

  /// Creates a [FirstSemesterSubmitted] event.
  const FirstSemesterSubmitted({
    required this.semesterName,
    required this.subjects,
  });

  @override
  List<Object?> get props => [semesterName, subjects];
}
