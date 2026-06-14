import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A horizontal stepper widget for selecting a numeric credit value.
///
/// Displays a minus button, the current value, and a plus button. A "CREDITS"
/// label is rendered to the left of the stepper control. Tapping minus/plus
/// increments or decrements the value by [step], clamped to [[min], [max]].
///
/// Example:
/// ```dart
/// CreditStepper(
///   value: subject.credit,
///   onChanged: (credit) => onChanged(subject.copyWith(credit: credit)),
/// )
/// ```
class CreditStepper extends StatelessWidget {
  /// The current credit value.
  final double value;

  /// Called when the user taps minus or plus, passing the new value.
  final ValueChanged<double> onChanged;

  /// The minimum selectable value. Defaults to 0.5.
  final double min;

  /// The maximum selectable value. Defaults to 10.
  final double max;

  /// The amount to increment or decrement per tap. Defaults to 0.5.
  final double step;

  /// Creates a [CreditStepper].
  const CreditStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.5,
    this.max = 10,
    this.step = 0.5,
  });

  /// Formats [value] as an integer string when it has no fractional part,
  /// otherwise as a one-decimal string (e.g., "3" or "2.5").
  String _formatValue(double v) {
    return v == v.truncateToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'CREDITS',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPlaceholder,
            letterSpacing: 0.04 * 10,
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Container(
          padding: const EdgeInsets.all(AppSpacing.space4),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppSpacing.borderRadiusMedium,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepperButton(
                icon: LucideIcons.minus,
                onTap: value > min
                    ? () => onChanged(
                          double.parse(
                            (value - step).clamp(min, max).toStringAsFixed(1),
                          ),
                        )
                    : null,
              ),
              SizedBox(
                width: 36,
                child: Center(
                  child: Text(
                    _formatValue(value),
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              _StepperButton(
                icon: LucideIcons.plus,
                onTap: value < max
                    ? () => onChanged(
                          double.parse(
                            (value + step).clamp(min, max).toStringAsFixed(1),
                          ),
                        )
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// An individual icon button used inside [CreditStepper].
class _StepperButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Called when the button is tapped. Null disables the button.
  final VoidCallback? onTap;

  /// Creates a [_StepperButton].
  const _StepperButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMedium.subtract(
            const BorderRadius.all(Radius.circular(2)),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? AppColors.textPrimary : AppColors.disabled,
        ),
      ),
    );
  }
}
