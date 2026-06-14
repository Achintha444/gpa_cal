import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/user_details.dart';

/// The loading / action status for the settings screen.
enum SettingsStatus {
  /// The initial state before any data has been requested.
  initial,

  /// Settings data is being loaded.
  loading,

  /// Data loaded successfully and the settings UI is ready.
  success,

  /// A profile or GPA-type update is in progress.
  updating,

  /// A data-clear operation is in progress.
  clearing,

  /// All data has been cleared — the app should navigate to welcome.
  cleared,

  /// An error occurred during loading or updating.
  error,
}

/// The state for [SettingsBloc].
///
/// Holds the currently loaded [UserDetails] alongside the screen status
/// and any error message.
class SettingsState extends Equatable {
  /// The current status of the settings screen.
  final SettingsStatus status;

  /// The user's current profile details. Null until loaded.
  final UserDetails? userDetails;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates a [SettingsState].
  const SettingsState({
    this.status = SettingsStatus.initial,
    this.userDetails,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, userDetails, errorMessage];

  /// Creates a copy of this state with the given fields replaced.
  SettingsState copyWith({
    SettingsStatus? status,
    UserDetails? userDetails,
    String? errorMessage,
  }) {
    return SettingsState(
      status: status ?? this.status,
      userDetails: userDetails ?? this.userDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
