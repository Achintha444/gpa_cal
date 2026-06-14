import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/settings/presentation/bloc/settings_event.dart';
import 'package:gpa_cal/features/settings/presentation/bloc/settings_state.dart';

/// Manages the state of the settings screen.
///
/// Loads user profile data on [SettingsDataRequested]. Handles GPA scale
/// changes via [GpaTypeChanged], profile edits via [ProfileUpdated], and
/// the data-clear flow via [ClearAllDataRequested]. On a successful clear,
/// emits [SettingsStatus.cleared] so the UI can navigate to `/welcome`.
///
/// The [UserDetailsRepository.clearAll] implementation deletes both user
/// details and all semester data — no separate [SemesterRepository] is needed.
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// Logger for this BLoC.
  static final Log _log = Log('SettingsBloc');

  /// Repository for loading and saving user profile details and GPA type.
  ///
  /// Also used for clearing all data — [UserDetailsRepository.clearAll]
  /// removes both profile and semester data.
  final UserDetailsRepository _userDetailsRepository;

  /// Creates a [SettingsBloc] with the required repository.
  SettingsBloc({
    required UserDetailsRepository userDetailsRepository,
  })  : _userDetailsRepository = userDetailsRepository,
        super(const SettingsState()) {
    on<SettingsDataRequested>(_onSettingsDataRequested);
    on<GpaTypeChanged>(_onGpaTypeChanged);
    on<ClearAllDataRequested>(_onClearAllDataRequested);
    on<ProfileUpdated>(_onProfileUpdated);
  }

  /// Handles [SettingsDataRequested] — loads the user's profile.
  ///
  /// Emits [SettingsStatus.loading] then [SettingsStatus.success] on success,
  /// or [SettingsStatus.error] on failure.
  Future<void> _onSettingsDataRequested(
    SettingsDataRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    try {
      final UserDetails userDetails =
          await _userDetailsRepository.getUserDetails();

      _log.d(
        'SettingsDataRequested: loaded name=${userDetails.name}, '
        'gpaType=${userDetails.gpaType}',
      );

      emit(state.copyWith(
        status: SettingsStatus.success,
        userDetails: userDetails,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('SettingsDataRequested failed: $e');
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to load settings. Please try again.',
      ));
    }
  }

  /// Handles [GpaTypeChanged] — updates the GPA scale preference.
  ///
  /// Persists the change and emits the updated [UserDetails]. Reverts to
  /// [SettingsStatus.error] on failure.
  Future<void> _onGpaTypeChanged(
    GpaTypeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final UserDetails? current = state.userDetails;
    if (current == null) return;

    emit(state.copyWith(status: SettingsStatus.updating));

    try {
      final UserDetails updated = current.copyWith(gpaType: event.gpaType);
      await _userDetailsRepository.saveUserDetails(updated);

      _log.d('GpaTypeChanged: saved gpaType=${event.gpaType}');

      emit(state.copyWith(
        status: SettingsStatus.success,
        userDetails: updated,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('GpaTypeChanged failed: $e');
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to update GPA scale. Please try again.',
      ));
    }
  }

  /// Handles [ClearAllDataRequested] — deletes all user data.
  ///
  /// Calls [UserDetailsRepository.clearAll] (which also clears semester data).
  /// On success, emits [SettingsStatus.cleared] so the UI navigates to welcome.
  Future<void> _onClearAllDataRequested(
    ClearAllDataRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.clearing));

    try {
      await _userDetailsRepository.clearAll();
      _log.d('ClearAllDataRequested: all data cleared');
      emit(state.copyWith(status: SettingsStatus.cleared, errorMessage: ''));
    } catch (e) {
      _log.e('ClearAllDataRequested failed: $e');
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to clear data. Please try again.',
      ));
    }
  }

  /// Handles [ProfileUpdated] — saves the user's updated name and university.
  ///
  /// Preserves the existing GPA type. On success emits [SettingsStatus.success]
  /// with the updated [UserDetails].
  Future<void> _onProfileUpdated(
    ProfileUpdated event,
    Emitter<SettingsState> emit,
  ) async {
    final UserDetails? current = state.userDetails;
    if (current == null) return;

    emit(state.copyWith(status: SettingsStatus.updating));

    try {
      final UserDetails updated = current.copyWith(
        name: event.name,
        university: event.university,
      );
      await _userDetailsRepository.saveUserDetails(updated);

      _log.d(
        'ProfileUpdated: saved name=${event.name}, '
        'university=${event.university}',
      );

      emit(state.copyWith(
        status: SettingsStatus.success,
        userDetails: updated,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('ProfileUpdated failed: $e');
      emit(state.copyWith(
        status: SettingsStatus.error,
        errorMessage: 'Failed to save profile. Please try again.',
      ));
    }
  }
}
