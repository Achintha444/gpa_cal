import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// A centered empty-state placeholder with an icon, headline, body, and
/// an optional call-to-action button.
///
/// Used when a list or data area has no content to display — for example,
/// when no semesters have been added yet.
///
/// Example:
/// ```dart
/// EmptyStateView(
///   icon: LucideIcons.graduationCap,
///   headline: 'No semesters yet',
///   body: 'Add your first semester to start tracking your GPA.',
///   ctaLabel: 'Add Semester',
///   onCtaTap: () => context.pushNamed('addSemester', ...),
/// )
/// ```
class EmptyStateView extends StatelessWidget {
  /// The icon displayed inside the accent circle.
  final IconData icon;

  /// The primary headline text shown below the icon.
  final String headline;

  /// The supporting body text shown below the headline.
  final String body;

  /// Label for the optional call-to-action button. Null hides the button.
  final String? ctaLabel;

  /// Called when the CTA button is tapped. Null disables the button.
  final VoidCallback? onCtaTap;

  /// Creates an [EmptyStateView].
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.headline,
    required this.body,
    this.ctaLabel,
    this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIconCircle(),
            const SizedBox(height: AppSpacing.space16),
            Text(
              headline,
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space8),
            Text(
              body,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCtaTap != null) ...[
              const SizedBox(height: AppSpacing.space24),
              _buildCtaButton(),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the 80×80 accent-tinted circle containing the icon.
  Widget _buildIconCircle() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.accentTint,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 40,
        // Accent at ~45% opacity: pre-computed alpha 0x73 = 115/255 ≈ 45%.
        color: Color(0x732563EB),
      ),
    );
  }

  /// Builds the optional CTA [ElevatedButton].
  Widget _buildCtaButton() {
    return ElevatedButton(
      onPressed: onCtaTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.surface,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space24,
          vertical: AppSpacing.space12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusMedium,
        ),
        textStyle: AppTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      child: Text(ctaLabel!),
    );
  }
}
