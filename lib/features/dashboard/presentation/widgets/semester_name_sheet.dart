import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// A bottom sheet for entering a name when creating a new semester.
///
/// Displays a text field with a 20-character limit, a character counter, and
/// "Cancel" / "Create" action buttons. The "Create" button is disabled while
/// the name is empty. On confirm, pops the sheet returning the entered name.
///
/// Usage:
/// ```dart
/// final String? name = await showModalBottomSheet<String>(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => const SemesterNameSheet(),
/// );
/// if (name != null) {
///   // navigate to add-semester with name
/// }
/// ```
class SemesterNameSheet extends StatefulWidget {
  /// Creates a [SemesterNameSheet].
  const SemesterNameSheet({super.key});

  @override
  State<SemesterNameSheet> createState() => _SemesterNameSheetState();
}

class _SemesterNameSheetState extends State<SemesterNameSheet> {
  /// Controller for the semester name text field.
  late final TextEditingController _controller;

  /// The maximum number of characters allowed in the semester name.
  static const int _maxLength = 20;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Whether the Create button should be enabled.
  bool get _canCreate => _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return DecoratedBox(
      decoration: AppDecorations.bottomSheet,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.space16,
            AppSpacing.screenPadding,
            AppSpacing.space24 + bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDragHandle(),
              const SizedBox(height: AppSpacing.space20),
              Text('New Semester', style: AppTypography.titleLarge),
              const SizedBox(height: AppSpacing.space16),
              _buildNameField(),
              const SizedBox(height: AppSpacing.space4),
              _buildCharacterCounter(),
              const SizedBox(height: AppSpacing.space20),
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

  /// Builds the semester name text input field.
  Widget _buildNameField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppSpacing.borderRadiusMedium,
      ),
      child: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        textCapitalization: TextCapitalization.words,
        style: AppTypography.bodyMedium,
        textAlignVertical: TextAlignVertical.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(_maxLength),
        ],
        decoration: InputDecoration(
          hintText: 'Semester name',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPlaceholder,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: 0,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _onCreate(context),
      ),
    );
  }

  /// Builds the "N / 20" character counter aligned to the right.
  Widget _buildCharacterCounter() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        '${_controller.text.length} / $_maxLength',
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textPlaceholder,
        ),
      ),
    );
  }

  /// Builds the Cancel / Create button row.
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _canCreate ? () => _onCreate(context) : null,
              child: const Text('Create'),
            ),
          ),
        ),
      ],
    );
  }

  /// Pops the sheet and returns the trimmed semester name.
  void _onCreate(BuildContext context) {
    final String name = _controller.text.trim();
    if (name.isNotEmpty) {
      Navigator.of(context).pop(name);
    }
  }
}
