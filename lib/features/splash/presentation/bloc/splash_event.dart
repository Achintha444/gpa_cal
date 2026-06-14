import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [SplashBloc].
sealed class SplashEvent extends Equatable {
  /// Creates a [SplashEvent].
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Triggers the splash check to determine whether the user has completed
/// onboarding or needs to be directed to the welcome flow.
final class SplashCheckRequested extends SplashEvent {
  /// Creates a [SplashCheckRequested] event.
  const SplashCheckRequested();
}
