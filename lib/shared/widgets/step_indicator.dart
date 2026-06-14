import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// A step progress indicator for multi-step flows such as onboarding.
///
/// Displays a "STEP X OF Y" label above a segmented progress bar. Active
/// segments (indices up to and including [currentStep] − 1) are filled with
/// [AppColors.accent]; inactive segments use [AppColors.border].
///
/// Example:
/// ```dart
/// StepIndicator(currentStep: 2, totalSteps: 3)
/// ```
class StepIndicator extends StatelessWidget {
  /// The 1-based index of the current step (1 ≤ currentStep ≤ totalSteps).
  final int currentStep;

  /// The total number of steps in the flow.
  final int totalSteps;

  /// Creates a [StepIndicator].
  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP $currentStep OF $totalSteps',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.02 * 12,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        _buildProgressBar(),
      ],
    );
  }

  /// Builds the segmented progress bar row.
  Widget _buildProgressBar() {
    return Row(
      children: List.generate(totalSteps, (int index) {
        final bool isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: index < totalSteps - 1
                ? const EdgeInsets.only(right: 6.0)
                : EdgeInsets.zero,
            height: 4,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.border,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
        );
      }),
    );
  }
}
