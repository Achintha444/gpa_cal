import 'package:equatable/equatable.dart';

/// The loading status for onboarding submission operations.
enum OnboardingStatus {
  /// No submission in progress — the user is editing fields.
  initial,

  /// A save operation is in progress.
  loading,

  /// The save operation completed successfully.
  success,

  /// The save operation failed.
  error,
}

/// The state managed by [OnboardingBloc].
///
/// Holds all form field values for both the profile setup and first semester
/// screens, along with the submission status and any error message.
class OnboardingState extends Equatable {
  /// The user's entered name.
  final String name;

  /// The user's entered university or school name.
  final String university;

  /// The selected GPA scale type: `0` = 4.0 scale, `1` = 4.2 scale.
  ///
  /// Defaults to `1` (4.2 scale) as it is more common among the target user base.
  final int gpaType;

  /// The current loading/submission status.
  final OnboardingStatus status;

  /// The error message to display when [status] is [OnboardingStatus.error].
  ///
  /// Empty string when no error is present.
  final String errorMessage;

  /// Creates an [OnboardingState].
  const OnboardingState({
    this.name = '',
    this.university = '',
    this.gpaType = 1,
    this.status = OnboardingStatus.initial,
    this.errorMessage = '',
  });

  /// Whether the profile form is valid and ready to submit.
  ///
  /// Both [name] and [university] must be non-empty after trimming.
  bool get isProfileValid =>
      name.trim().isNotEmpty && university.trim().isNotEmpty;

  @override
  List<Object?> get props => [name, university, gpaType, status, errorMessage];

  /// Creates a copy of this [OnboardingState] with the given fields replaced.
  OnboardingState copyWith({
    String? name,
    String? university,
    int? gpaType,
    OnboardingStatus? status,
    String? errorMessage,
  }) {
    return OnboardingState(
      name: name ?? this.name,
      university: university ?? this.university,
      gpaType: gpaType ?? this.gpaType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
