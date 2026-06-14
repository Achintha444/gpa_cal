import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [SettingsBloc].
sealed class SettingsEvent extends Equatable {
  /// Creates a [SettingsEvent].
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the user's settings data to be loaded.
///
/// Dispatched on screen mount to populate the settings page with
/// the user's current profile and GPA scale preference.
final class SettingsDataRequested extends SettingsEvent {
  /// Creates a [SettingsDataRequested] event.
  const SettingsDataRequested();
}

/// Fires when the user toggles the GPA scale between 4.0 and 4.2.
final class GpaTypeChanged extends SettingsEvent {
  /// The new GPA type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Creates a [GpaTypeChanged] event.
  const GpaTypeChanged(this.gpaType);

  @override
  List<Object?> get props => [gpaType];
}

/// Fires when the user confirms clearing all app data.
///
/// On completion the app should navigate to `/welcome`.
final class ClearAllDataRequested extends SettingsEvent {
  /// Creates a [ClearAllDataRequested] event.
  const ClearAllDataRequested();
}

/// Fires when the user saves profile edits from the profile edit sheet.
final class ProfileUpdated extends SettingsEvent {
  /// The updated name.
  final String name;

  /// The updated university.
  final String university;

  /// Creates a [ProfileUpdated] event.
  const ProfileUpdated({required this.name, required this.university});

  @override
  List<Object?> get props => [name, university];
}
