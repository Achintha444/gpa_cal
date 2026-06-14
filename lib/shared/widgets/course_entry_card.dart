import 'package:flutter/material.dart';
import 'package:gpa_cal/core/constants/gpa_tables.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/shared/widgets/credit_stepper.dart';
import 'package:gpa_cal/shared/widgets/grade_chip_selector.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// A card widget for entering or editing a single course within a semester.
///
/// Displays a course name text field, a [GradeChipSelector], and a
/// [CreditStepper]. An optional delete button is shown when [canDelete] is
/// true. Changes to any field invoke [onChanged] with an updated [Subject].
///
/// Example:
/// ```dart
/// CourseEntryCard(
///   subject: subject,
///   index: 0,
///   canDelete: subjects.length > 1,
///   gpaType: gpaType,
///   onChanged: (updated) => bloc.add(SubjectUpdated(index: 0, subject: updated)),
///   onDelete: () => bloc.add(SubjectDeleted(index: 0)),
/// )
/// ```
class CourseEntryCard extends StatefulWidget {
  /// The subject data backing this card.
  final Subject subject;

  /// The zero-based position of this card in the subject list.
  final int index;

  /// Whether the delete button is shown. Pass false when only one course exists.
  final bool canDelete;

  /// The grading scale type: 0 for 4.0 scale, 1 for 4.2 scale.
  final int gpaType;

  /// Called whenever the course name, grade, or credit changes.
  final ValueChanged<Subject> onChanged;

  /// Called when the user taps the delete button.
  final VoidCallback onDelete;

  /// Creates a [CourseEntryCard].
  const CourseEntryCard({
    super.key,
    required this.subject,
    required this.index,
    required this.canDelete,
    required this.gpaType,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<CourseEntryCard> createState() => _CourseEntryCardState();
}

class _CourseEntryCardState extends State<CourseEntryCard> {
  /// Controller for the course name input field.
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.subject.courseName);
  }

  @override
  void didUpdateWidget(CourseEntryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller text if the subject changed externally without losing cursor.
    if (oldWidget.subject.courseName != widget.subject.courseName &&
        _controller.text != widget.subject.courseName) {
      _controller.text = widget.subject.courseName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> grades = GpaTables.gradesFor(widget.gpaType);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppDecorations.cardFlat,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopRow(),
          const SizedBox(height: AppSpacing.space12),
          GradeChipSelector(
            grades: grades,
            selectedGrade:
                widget.subject.grade.isEmpty ? null : widget.subject.grade,
            onGradeSelected: (String grade) {
              widget.onChanged(widget.subject.copyWith(grade: grade));
            },
          ),
          const SizedBox(height: AppSpacing.space12),
          _buildCreditsRow(),
        ],
      ),
    );
  }

  /// Builds the top row containing the course name field and delete button.
  Widget _buildTopRow() {
    return Row(
      children: [
        Expanded(child: _buildCourseNameField()),
        if (widget.canDelete) ...[
          const SizedBox(width: AppSpacing.space8),
          _buildDeleteButton(),
        ],
      ],
    );
  }

  /// Builds the course name text input field.
  Widget _buildCourseNameField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppSpacing.borderRadiusMedium.subtract(
          const BorderRadius.all(Radius.circular(2)),
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: (String text) {
          widget.onChanged(widget.subject.copyWith(courseName: text));
        },
        style: AppTypography.bodyMedium,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: 'Course name',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPlaceholder,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  /// Builds the delete button shown when [widget.canDelete] is true.
  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: widget.onDelete,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.errorTint,
          borderRadius: AppSpacing.borderRadiusMedium.subtract(
            const BorderRadius.all(Radius.circular(2)),
          ),
        ),
        child: const Icon(
          LucideIcons.trash2,
          size: 18,
          color: AppColors.error,
        ),
      ),
    );
  }

  /// Builds the credits row with a label on the left and a [CreditStepper] on the right.
  Widget _buildCreditsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Credits',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        CreditStepper(
          value: widget.subject.credit,
          onChanged: (double credit) {
            widget.onChanged(widget.subject.copyWith(credit: credit));
          },
        ),
      ],
    );
  }
}
