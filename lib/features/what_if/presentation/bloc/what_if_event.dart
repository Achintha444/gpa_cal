import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [WhatIfBloc].
sealed class WhatIfEvent extends Equatable {
  /// Creates a [WhatIfEvent].
  const WhatIfEvent();

  @override
  List<Object?> get props => [];
}

/// Initialises the what-if calculator by loading the user's current data.
///
/// Dispatched on screen mount to load CGPA and GPA type from repositories.
final class WhatIfInitialized extends WhatIfEvent {
  /// Creates a [WhatIfInitialized] event.
  const WhatIfInitialized();
}

/// Fired when the user changes the target CGPA input field.
final class TargetCgpaChanged extends WhatIfEvent {
  /// The new target CGPA value entered by the user.
  final double targetCgpa;

  /// Creates a [TargetCgpaChanged] event.
  const TargetCgpaChanged(this.targetCgpa);

  @override
  List<Object?> get props => [targetCgpa];
}

/// Fired when the user changes the number of courses for the next semester.
final class NumCoursesChanged extends WhatIfEvent {
  /// The new number of courses (1–8).
  final int numCourses;

  /// Creates a [NumCoursesChanged] event.
  const NumCoursesChanged(this.numCourses);

  @override
  List<Object?> get props => [numCourses];
}

/// Fired when the user changes the credits-per-course stepper.
final class CreditsPerCourseChanged extends WhatIfEvent {
  /// The new credits-per-course value (0.5–10 in 0.5 increments).
  final double creditsPerCourse;

  /// Creates a [CreditsPerCourseChanged] event.
  const CreditsPerCourseChanged(this.creditsPerCourse);

  @override
  List<Object?> get props => [creditsPerCourse];
}
