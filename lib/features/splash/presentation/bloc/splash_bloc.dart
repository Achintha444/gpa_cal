import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/splash/presentation/bloc/splash_event.dart';
import 'package:gpa_cal/features/splash/presentation/bloc/splash_state.dart';

/// Manages the splash screen logic for GPA Cal.
///
/// On [SplashCheckRequested], checks if the user has completed onboarding
/// by querying [UserDetailsRepository.hasUserDetails]. Emits
/// [SplashAuthenticated] with the loaded [UserDetails] if onboarding is
/// complete, or [SplashUnauthenticated] if the app is being launched for
/// the first time.
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  /// Logger for this BLoC.
  static final Log _log = Log('SplashBloc');

  /// The repository used to check and load user profile data.
  final UserDetailsRepository _userDetailsRepository;

  /// Creates a [SplashBloc] with the given [userDetailsRepository].
  SplashBloc({required UserDetailsRepository userDetailsRepository})
      : _userDetailsRepository = userDetailsRepository,
        super(const SplashInitial()) {
    on<SplashCheckRequested>(_onSplashCheckRequested);
  }

  /// Handles the [SplashCheckRequested] event.
  ///
  /// Checks whether user details exist. If they do, loads them and emits
  /// [SplashAuthenticated]. Otherwise emits [SplashUnauthenticated].
  Future<void> _onSplashCheckRequested(
    SplashCheckRequested event,
    Emitter<SplashState> emit,
  ) async {
    try {
      final bool hasDetails = await _userDetailsRepository.hasUserDetails();

      if (hasDetails) {
        final UserDetails userDetails =
            await _userDetailsRepository.getUserDetails();
        _log.d('SplashCheck: user authenticated as "${userDetails.name}"');
        emit(SplashAuthenticated(userDetails));
      } else {
        _log.d('SplashCheck: no user details found, directing to onboarding');
        emit(const SplashUnauthenticated());
      }
    } catch (e) {
      _log.e('SplashCheck failed: $e');
      // Treat any error as unauthenticated so the user can re-onboard.
      emit(const SplashUnauthenticated());
    }
  }
}
