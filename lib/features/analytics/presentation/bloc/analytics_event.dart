import 'package:equatable/equatable.dart';

/// Base class for all events dispatched to [AnalyticsBloc].
sealed class AnalyticsEvent extends Equatable {
  /// Creates an [AnalyticsEvent].
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Requests the analytics data to be loaded from the repositories.
///
/// Dispatched on screen mount to trigger loading of the [UserResult]
/// and computation of all analytics metrics.
final class AnalyticsDataRequested extends AnalyticsEvent {
  /// Creates an [AnalyticsDataRequested] event.
  const AnalyticsDataRequested();
}
