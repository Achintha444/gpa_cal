import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_event.dart';
import 'package:gpa_cal/features/edit_semester/presentation/bloc/edit_semester_bloc.dart';
import 'package:gpa_cal/features/edit_semester/presentation/bloc/edit_semester_event.dart';
import 'package:gpa_cal/features/edit_semester/presentation/bloc/edit_semester_state.dart';
import 'package:gpa_cal/features/edit_semester/presentation/widgets/delete_confirm_sheet.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The screen for editing an existing semester's name and courses.
///
/// Accepts [semesterHash] from the route path parameter and an optional
/// [gpaType] from route extras. Provides a scoped [EditSemesterBloc] and
/// handles loading, editing, saving, and deletion states.
///
/// Route path: `/edit-semester/:hash`
class EditSemesterPage extends StatelessWidget {
  /// The unique hash of the semester to edit.
  final int semesterHash;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  ///
  /// Used to initialise the [EditSemesterBloc] with the correct grade scale.
  /// Defaults to `0` when not provided via route extras.
  final int gpaType;

  /// Creates an [EditSemesterPage].
  const EditSemesterPage({
    super.key,
    required this.semesterHash,
    this.gpaType = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditSemesterBloc>(
      create: (BuildContext ctx) => EditSemesterBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
      )..add(EditSemesterInitialized(semesterHash, gpaType: gpaType)),
      child: _EditSemesterView(semesterHash: semesterHash, gpaType: gpaType),
    );
  }
}

/// The inner view that observes [EditSemesterBloc] state.
class _EditSemesterView extends StatelessWidget {
  /// The semester hash, forwarded to the delete confirmation flow.
  final int semesterHash;

  /// The GPA type to display grade chips on the correct scale.
  final int gpaType;

  /// Creates an [_EditSemesterView].
  const _EditSemesterView({
    required this.semesterHash,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditSemesterBloc, EditSemesterState>(
      listenWhen: (EditSemesterState prev, EditSemesterState curr) =>
          curr.status != prev.status,
      listener: (BuildContext ctx, EditSemesterState state) {
        if (state.status == EditSemesterStatus.saved) {
          ctx.read<HomeBloc>().add(const HomeDataRequested());
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Semester saved successfully.'),
              backgroundColor: AppColors.textPrimary,
            ),
          );
          Navigator.of(ctx).pop();
        } else if (state.status == EditSemesterStatus.deleted) {
          ctx.read<HomeBloc>().add(const HomeDataRequested());
          ctx.goNamed(AppRoutes.home);
        } else if (state.status == EditSemesterStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (BuildContext context, EditSemesterState state) {
        if (state.status == EditSemesterStatus.loading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        if (state.status == EditSemesterStatus.error &&
            state.subjects.isEmpty) {
          return _FullErrorView(
            message: state.errorMessage,
            semesterHash: semesterHash,
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _EditAppBar(
                  semesterName: state.semesterName,
                  onDelete: () => _showDeleteSheet(context),
                ),
                BlocBuilder<EditSemesterBloc, EditSemesterState>(
                  buildWhen: (EditSemesterState prev, EditSemesterState curr) =>
                      prev.sgpa != curr.sgpa,
                  builder: (BuildContext _, EditSemesterState s) =>
                      SgpaBar(sgpa: s.sgpa),
                ),
                Expanded(
                  child: _CourseList(state: state, gpaType: gpaType),
                ),
                _SaveButton(state: state),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows the [DeleteConfirmSheet] and triggers deletion on confirmation.
  Future<void> _showDeleteSheet(BuildContext context) async {
    final bool? confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DeleteConfirmSheet(),
    );

    if (confirmed == true && context.mounted) {
      context.read<EditSemesterBloc>().add(const SemesterDeleteRequested());
    }
  }
}

/// Full-screen error view shown when the semester cannot be loaded at all.
class _FullErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// The semester hash for retrying the load.
  final int semesterHash;

  /// Creates a [_FullErrorView].
  const _FullErrorView({
    required this.message,
    required this.semesterHash,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _EditAppBar(
              semesterName: '',
              onDelete: () {},
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.alertCircle,
                        size: 40,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: AppSpacing.space16),
                      Text(
                        message.isNotEmpty
                            ? message
                            : 'Something went wrong.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.space24),
                      ElevatedButton.icon(
                        onPressed: () => context
                            .read<EditSemesterBloc>()
                            .add(EditSemesterInitialized(semesterHash)),
                        icon: const Icon(LucideIcons.refreshCw, size: 16),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The custom app bar row for the edit-semester screen.
///
/// Shows a back button, centered "Edit Semester" title, and a red trash icon
/// for triggering deletion.
class _EditAppBar extends StatelessWidget {
  /// The semester name shown as the subtitle.
  final String semesterName;

  /// Called when the trash icon is tapped.
  final VoidCallback onDelete;

  /// Creates an [_EditAppBar].
  const _EditAppBar({
    required this.semesterName,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.chevronLeft, size: 20),
            color: AppColors.textPrimary,
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Edit Semester', style: AppTypography.titleMedium),
                if (semesterName.isNotEmpty)
                  Text(
                    semesterName,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2, size: 18),
            color: AppColors.error,
            onPressed: semesterName.isNotEmpty ? onDelete : null,
          ),
        ],
      ),
    );
  }
}

/// The scrollable list of course entry cards plus the add button for editing.
class _CourseList extends StatelessWidget {
  /// The current edit-semester state.
  final EditSemesterState state;

  /// The GPA scale type for the grade chip selector.
  final int gpaType;

  /// Creates a [_CourseList].
  const _CourseList({required this.state, required this.gpaType});

  @override
  Widget build(BuildContext context) {
    // Use the effective gpaType from state (set during init) or fallback.
    final int effectiveGpaType =
        state.gpaType != 0 ? state.gpaType : gpaType;

    return CustomScrollView(
      slivers: [
        // Semester name field
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space20,
              AppSpacing.screenPadding,
              AppSpacing.space16,
            ),
            child: _SemesterNameField(semesterName: state.semesterName),
          ),
        ),
        // "Courses · N" section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.space12,
            ),
            child: Text(
              'Courses · ${state.subjects.length}',
              style: AppTypography.titleMedium,
            ),
          ),
        ),
        // Course cards
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int index) {
              final Subject subject = state.subjects[index];
              return Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.space12,
                ),
                child: CourseEntryCard(
                  key: ValueKey<int>(index),
                  subject: subject,
                  index: index,
                  canDelete: state.subjects.length > 1,
                  gpaType: effectiveGpaType,
                  onChanged: (Subject updated) => context
                      .read<EditSemesterBloc>()
                      .add(CourseUpdated(index: index, subject: updated)),
                  onDelete: () => context
                      .read<EditSemesterBloc>()
                      .add(CourseDeleted(index)),
                ),
              );
            },
            childCount: state.subjects.length,
          ),
        ),
        // "+ Add Another Course" button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.space12,
            ),
            child: _AddCourseButton(
              onTap: () =>
                  context.read<EditSemesterBloc>().add(const CourseAdded()),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.space16)),
      ],
    );
  }
}

/// The semester name editable text field shown at the top of the edit form.
class _SemesterNameField extends StatefulWidget {
  /// The initial semester name.
  final String semesterName;

  /// Creates a [_SemesterNameField].
  const _SemesterNameField({required this.semesterName});

  @override
  State<_SemesterNameField> createState() => _SemesterNameFieldState();
}

class _SemesterNameFieldState extends State<_SemesterNameField> {
  /// Controller synced to the semester name in state.
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.semesterName);
  }

  @override
  void didUpdateWidget(_SemesterNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.semesterName != widget.semesterName &&
        _controller.text != widget.semesterName) {
      _controller.text = widget.semesterName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      style: AppTypography.bodyMedium,
      decoration: const InputDecoration(
        labelText: 'SEMESTER NAME',
      ),
      onChanged: (String value) {
        context.read<EditSemesterBloc>().add(SemesterNameChanged(value));
      },
    );
  }
}

/// The dashed "+ Add Another Course" button.
class _AddCourseButton extends StatelessWidget {
  /// Called when the button is tapped.
  final VoidCallback onTap;

  /// Creates an [_AddCourseButton].
  const _AddCourseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: AppSpacing.borderRadiusLarge,
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.plus, size: 16, color: AppColors.accent),
            const SizedBox(width: AppSpacing.space8),
            Text(
              'Add Another Course',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The sticky bottom "Save Changes" button bar.
class _SaveButton extends StatelessWidget {
  /// The current edit-semester state.
  final EditSemesterState state;

  /// Creates a [_SaveButton].
  const _SaveButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final bool isSaving = state.status == EditSemesterStatus.saving;
    final bool canSave = state.hasChanges && !isSaving;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.space12,
        AppSpacing.screenPadding,
        AppSpacing.space20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: canSave
              ? () =>
                  context.read<EditSemesterBloc>().add(const SemesterSaved())
              : null,
          icon: isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.surface,
                  ),
                )
              : const Icon(LucideIcons.check, size: 18),
          label: const Text('Save Changes'),
          iconAlignment: IconAlignment.end,
        ),
      ),
    );
  }
}
