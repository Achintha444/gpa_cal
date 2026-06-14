import 'package:flutter/material.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:google_fonts/google_fonts.dart';

/// A horizontal wrapping row of tappable grade chips for selecting a letter grade.
///
/// Chips are grouped by grade band (A, B, C, D/F) and each band has its own
/// color scheme in both selected and unselected states. A "GRADE" label is
/// rendered above the chip group.
///
/// Example:
/// ```dart
/// GradeChipSelector(
///   grades: GpaTables.gradesFor(gpaType),
///   selectedGrade: subject.grade,
///   onGradeSelected: (grade) => onChanged(subject.copyWith(grade: grade)),
/// )
/// ```
class GradeChipSelector extends StatelessWidget {
  /// The ordered list of grade strings to display as chips.
  final List<String> grades;

  /// The currently selected grade string, or null if none is selected.
  final String? selectedGrade;

  /// Called when the user taps a chip, passing the selected grade string.
  final ValueChanged<String> onGradeSelected;

  /// Creates a [GradeChipSelector].
  const GradeChipSelector({
    super.key,
    required this.grades,
    required this.selectedGrade,
    required this.onGradeSelected,
  });

  /// Returns the background color for a chip in its unselected state.
  Color _unselectedBackground(String grade) {
    if (_isARange(grade)) return AppColors.accentTint;
    if (_isBRange(grade)) return AppColors.warningTint;
    if (_isCRange(grade)) return AppColors.surfaceMuted;
    return AppColors.errorTint;
  }

  /// Returns the text color for a chip in its unselected state.
  Color _unselectedTextColor(String grade) {
    if (_isARange(grade)) return AppColors.accent;
    if (_isBRange(grade)) return AppColors.gpa;
    if (_isCRange(grade)) return AppColors.textSecondary;
    return AppColors.error;
  }

  /// Returns the background color for a chip in its selected state.
  Color _selectedBackground(String grade) {
    if (_isARange(grade)) return AppColors.accent;
    if (_isBRange(grade)) return AppColors.gpa;
    if (_isCRange(grade)) return AppColors.textSecondary;
    return AppColors.error;
  }

  /// Returns true if [grade] is in the A range (A+, A, A-).
  bool _isARange(String grade) => grade == 'A+' || grade == 'A' || grade == 'A-';

  /// Returns true if [grade] is in the B range (B+, B, B-).
  bool _isBRange(String grade) => grade == 'B+' || grade == 'B' || grade == 'B-';

  /// Returns true if [grade] is in the C range (C+, C, C-).
  bool _isCRange(String grade) => grade == 'C+' || grade == 'C' || grade == 'C-';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GRADE',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPlaceholder,
            letterSpacing: 0.04 * 10,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        Wrap(
          spacing: 6.0,
          runSpacing: 6.0,
          children: grades.map((String grade) => _GradeChip(
                grade: grade,
                isSelected: grade == selectedGrade,
                backgroundColor: grade == selectedGrade
                    ? _selectedBackground(grade)
                    : _unselectedBackground(grade),
                textColor: grade == selectedGrade
                    ? AppColors.surface
                    : _unselectedTextColor(grade),
                onTap: () => onGradeSelected(grade),
              )).toList(),
        ),
      ],
    );
  }
}

/// An individual selectable chip within [GradeChipSelector].
class _GradeChip extends StatelessWidget {
  /// The grade label displayed on this chip.
  final String grade;

  /// Whether this chip is currently selected.
  final bool isSelected;

  /// Background color for this chip's current state.
  final Color backgroundColor;

  /// Text color for this chip's current state.
  final Color textColor;

  /// Called when the chip is tapped.
  final VoidCallback onTap;

  /// Creates a [_GradeChip].
  const _GradeChip({
    required this.grade,
    required this.isSelected,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.space8,
          horizontal: AppSpacing.space12,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: AppSpacing.borderRadiusSmall,
        ),
        child: Text(
          grade,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
