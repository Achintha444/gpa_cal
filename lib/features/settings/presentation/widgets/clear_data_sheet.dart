import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A bottom sheet confirmation dialog for the "Clear All Data" action.
///
/// Shows a warning icon, a descriptive message, and two actions:
/// a destructive "Clear All Data" button and a "Cancel" link.
/// Returns `true` via [Navigator.pop] when the user confirms, `false`
/// (or `null`) when they cancel.
///
/// Usage:
/// ```dart
/// final bool? confirmed = await showModalBottomSheet<bool>(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => const ClearDataSheet(),
/// );
/// if (confirmed == true) { ... }
/// ```
class ClearDataSheet extends StatelessWidget {
  /// Creates a [ClearDataSheet].
  const ClearDataSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusTopXLarge,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: AppSpacing.space12),
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppSpacing.borderRadiusFull,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space24),

            // Warning icon
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.errorFeedbackTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.trash2,
                size: 28,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.space16),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Text(
                'Clear All Data?',
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.space8),

            // Body
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Text(
                'This will permanently delete all your semesters, courses, '
                'and profile data. This action cannot be undone.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.space32),

            // Confirm button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.surface,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.space16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMedium,
                    ),
                    textStyle: AppTypography.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Clear All Data'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space12),

            // Cancel
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space16),
          ],
        ),
      ),
    );
  }
}
