import 'package:flutter/material.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A tappable card displaying a semester's summary on the home dashboard.
///
/// Shows the semester name, course count, total credits, and SGPA. Tapping
/// the card invokes [onTap] for navigation to the edit semester screen.
///
/// Example:
/// ```dart
/// SemesterCard(
///   semester: semester,
///   onTap: () => context.pushNamed('editSemester', pathParameters: {'hash': '${semester.hash}'}),
/// )
/// ```
class SemesterCard extends StatelessWidget {
  /// The semester data to display.
  final Semester semester;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  /// Creates a [SemesterCard].
  const SemesterCard({
    super.key,
    required this.semester,
    required this.onTap,
  });

  /// Formats [sgpa] to two decimal places for display.
  String _formatSgpa(double sgpa) => sgpa.toStringAsFixed(2);

  @override
  Widget build(BuildContext context) {
    final int courseCount = semester.subjectList.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space20),
        decoration: AppDecorations.cardFlat,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: _buildLeftContent(courseCount)),
            const SizedBox(width: AppSpacing.space8),
            _buildRightContent(),
          ],
        ),
      ),
    );
  }

  /// Builds the left column with semester name and meta information.
  Widget _buildLeftContent(int courseCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          semester.name,
          style: AppTypography.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          '$courseCount ${courseCount == 1 ? 'course' : 'courses'} · '
          '${_formatCredits(semester.totalCredit)} credits',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Formats [credits] as an integer when it has no fractional part.
  String _formatCredits(double credits) {
    return credits == credits.truncateToDouble()
        ? credits.toInt().toString()
        : credits.toStringAsFixed(1);
  }

  /// Builds the right column with SGPA value and chevron icon.
  Widget _buildRightContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _formatSgpa(semester.sgpa),
          style: GoogleFonts.interTight(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.gpa,
            height: 1.0,
          ),
        ),
        const SizedBox(width: AppSpacing.space4),
        const Icon(
          LucideIcons.chevronRight,
          size: 16,
          color: AppColors.textPlaceholder,
        ),
      ],
    );
  }
}
