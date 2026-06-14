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
/// Dispatched on screen mount to load CGPA, total credits, and GPA type
/// from the repositories.
final class WhatIfInitialized extends WhatIfEvent {
  /// Creates a [WhatIfInitialized] event.
  const WhatIfInitialized();
}

/// Fired when the user changes the target CGPA input field.
///
/// The raw [value] string is parsed and validated inside the BLoC.
/// Values outside the valid scale range (0.00–max) are ignored.
final class TargetCgpaChanged extends WhatIfEvent {
  /// The raw string value from the text field.
  final String value;

  /// Creates a [TargetCgpaChanged] event.
  const TargetCgpaChanged(this.value);

  @override
  List<Object?> get props => [value];
}

/// Fired when the user adjusts the remaining semesters stepper.
///
/// [value] comes directly from [CreditStepper]. Valid range: 1–20, step 1.
final class RemainingSemestersChanged extends WhatIfEvent {
  /// The new remaining semesters value.
  final double value;

  /// Creates a [RemainingSemestersChanged] event.
  const RemainingSemestersChanged(this.value);

  @override
  List<Object?> get props => [value];
}

/// Fired when the user adjusts the total remaining credits stepper.
///
/// [value] comes directly from [CreditStepper] and is always in range.
/// Valid range: 1–200, step 1.
final class TotalRemainingCreditsChanged extends WhatIfEvent {
  /// The new total remaining credits value.
  final double value;

  /// Creates a [TotalRemainingCreditsChanged] event.
  const TotalRemainingCreditsChanged(this.value);

  @override
  List<Object?> get props => [value];
}
