import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A bottom sheet confirming deletion of a semester.
///
/// Shows a warning icon, title, and descriptive body text. Two buttons allow
/// the user to cancel or confirm the destructive delete action.
///
/// Usage:
/// ```dart
/// final bool? confirmed = await showModalBottomSheet<bool>(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => const DeleteConfirmSheet(),
/// );
/// if (confirmed == true) {
///   bloc.add(const SemesterDeleteRequested());
/// }
/// ```
class DeleteConfirmSheet extends StatelessWidget {
  /// Creates a [DeleteConfirmSheet].
  const DeleteConfirmSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.bottomSheet,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.space16,
            AppSpacing.screenPadding,
            AppSpacing.space24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              const SizedBox(height: AppSpacing.space24),
              _buildWarningIcon(),
              const SizedBox(height: AppSpacing.space16),
              Text(
                'Delete Semester?',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space8),
              Text(
                'This action cannot be undone. All courses and grades in this '
                'semester will be permanently removed.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.space24),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the drag handle at the top of the sheet.
  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: AppSpacing.borderRadiusFull,
        ),
      ),
    );
  }

  /// Builds the 56×56 circular warning icon in an error tint background.
  Widget _buildWarningIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.errorFeedbackTint,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        LucideIcons.alertCircle,
        size: 28,
        color: AppColors.error,
      ),
    );
  }

  /// Builds the Cancel / Delete action button row.
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(
                  // Error border at ~20% opacity: pre-computed 0x33 = 51/255 ≈ 20%.
                  color: Color(0x33DC2626),
                  width: 1.5,
                ),
              ),
              child: const Text('Delete'),
            ),
          ),
        ),
      ],
    );
  }
}
