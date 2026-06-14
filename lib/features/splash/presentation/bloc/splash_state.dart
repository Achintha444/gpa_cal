import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/user_details.dart';

/// Base class for all states emitted by [SplashBloc].
sealed class SplashState extends Equatable {
  /// Creates a [SplashState].
  const SplashState();

  @override
  List<Object?> get props => [];
}

/// The initial state before any check has been performed.
final class SplashInitial extends SplashState {
  /// Creates a [SplashInitial] state.
  const SplashInitial();
}

/// Emitted when the user has completed onboarding and has saved [UserDetails].
///
/// The splash screen should navigate to the home route when this state is received.
final class SplashAuthenticated extends SplashState {
  /// The user's saved profile details.
  final UserDetails userDetails;

  /// Creates a [SplashAuthenticated] state with the given [userDetails].
  const SplashAuthenticated(this.userDetails);

  @override
  List<Object?> get props => [userDetails];
}

/// Emitted when no user details are found, indicating onboarding is required.
///
/// The splash screen should navigate to the welcome route when this state is received.
final class SplashUnauthenticated extends SplashState {
  /// Creates a [SplashUnauthenticated] state.
  const SplashUnauthenticated();
}
