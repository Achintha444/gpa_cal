import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// A full-width bar displaying the live SGPA on the Add/Edit Semester screens.
///
/// Shows a "SGPA" label on the left and the calculated SGPA value on the right,
/// formatted to two decimal places. The bar uses a [AppColors.surfaceMuted]
/// background and [AppSpacing.screenPadding] horizontal insets.
///
/// Example:
/// ```dart
/// BlocBuilder<AddSemesterBloc, AddSemesterState>(
///   buildWhen: (prev, curr) => prev.sgpa != curr.sgpa,
///   builder: (context, state) => SgpaBar(sgpa: state.sgpa),
/// )
/// ```
class SgpaBar extends StatelessWidget {
  /// The SGPA value to display, formatted to two decimal places.
  final double sgpa;

  /// Creates an [SgpaBar].
  const SgpaBar({super.key, required this.sgpa});

  /// Formats [sgpa] to two decimal places.
  String _formatSgpa(double value) => value.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: AppColors.surfaceMuted,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'SGPA',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.08 * 12,
            ),
          ),
          Text(
            _formatSgpa(sgpa),
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.gpa,
            ),
          ),
        ],
      ),
    );
  }
}
