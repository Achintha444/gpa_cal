import 'package:flutter/material.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// A bottom sheet for editing the user's display name and university.
///
/// Pre-fills the fields with the user's current [userDetails]. The "Save"
/// button is disabled until at least one field differs from the original
/// values. Returns the updated [UserDetails] via [Navigator.pop] when saved,
/// or `null` when cancelled.
///
/// Usage:
/// ```dart
/// final UserDetails? updated = await showModalBottomSheet<UserDetails>(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => ProfileEditSheet(userDetails: userDetails),
/// );
/// if (updated != null) { ... }
/// ```
class ProfileEditSheet extends StatefulWidget {
  /// The user's current profile details used to pre-fill the fields.
  final UserDetails userDetails;

  /// Creates a [ProfileEditSheet].
  const ProfileEditSheet({super.key, required this.userDetails});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _universityController;

  /// Whether any field has changed from the original value.
  bool get _hasChanges =>
      _nameController.text.trim() != widget.userDetails.name.trim() ||
      _universityController.text.trim() !=
          widget.userDetails.university.trim();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userDetails.name);
    _universityController =
        TextEditingController(text: widget.userDetails.university);

    _nameController.addListener(_onFieldChanged);
    _universityController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  /// Triggers a rebuild so [_hasChanges] is re-evaluated.
  void _onFieldChanged() {
    setState(() {});
  }

  /// Validates and saves the updated profile.
  void _onSave() {
    final String name = _nameController.text.trim();
    final String university = _universityController.text.trim();

    if (name.isEmpty) return;

    Navigator.of(context).pop(
      widget.userDetails.copyWith(name: name, university: university),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Pushes the sheet above the keyboard.
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusTopXLarge,
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: AppSpacing.space20),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Text(
                  'Edit Profile',
                  style: AppTypography.headlineMedium,
                ),
              ),
              const SizedBox(height: AppSpacing.space24),

              // Name field
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: _ProfileTextField(
                  controller: _nameController,
                  label: 'NAME',
                  hint: 'Your name',
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: AppSpacing.space12),

              // University field
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: _ProfileTextField(
                  controller: _universityController,
                  label: 'UNIVERSITY',
                  hint: 'Your university',
                  textInputAction: TextInputAction.done,
                  onSubmitted: _hasChanges ? (_) => _onSave() : null,
                ),
              ),
              const SizedBox(height: AppSpacing.space24),

              // Save button
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: ElevatedButton(
                  onPressed: _hasChanges ? _onSave : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.surface,
                    disabledBackgroundColor: AppColors.disabled,
                    disabledForegroundColor: AppColors.surface,
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
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: AppSpacing.space8),

              // Cancel
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(
                    'Cancel',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.space16),
            ],
          ),
        ),
      ),
    );
  }
}

/// A labelled text field used inside [ProfileEditSheet].
///
/// Renders a small uppercase label above a filled text input that highlights
/// with an accent border on focus.
class _ProfileTextField extends StatefulWidget {
  /// The controller managing the field value.
  final TextEditingController controller;

  /// The uppercase label shown above the field.
  final String label;

  /// The placeholder hint text.
  final String hint;

  /// The keyboard action for this field.
  final TextInputAction textInputAction;

  /// Called when the user submits the field via the keyboard.
  final ValueChanged<String>? onSubmitted;

  /// Creates a [_ProfileTextField].
  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<_ProfileTextField> createState() => _ProfileTextFieldState();
}

class _ProfileTextFieldState extends State<_ProfileTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.08 * 12,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: _isFocused
              ? AppDecorations.inputFocused
              : AppDecorations.input,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
            vertical: AppSpacing.space12,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            textInputAction: widget.textInputAction,
            style: AppTypography.bodyLarge,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPlaceholder,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ],
    );
  }
}
