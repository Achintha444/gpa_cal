import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/features/add_semester/presentation/bloc/add_semester_bloc.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_event.dart';
import 'package:gpa_cal/features/add_semester/presentation/bloc/add_semester_event.dart';
import 'package:gpa_cal/features/add_semester/presentation/bloc/add_semester_state.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The screen for creating a new semester with courses.
///
/// Accepts [semesterName] and [gpaType] from route extras and initialises the
/// [AddSemesterBloc]. Navigates back to home when the semester is saved.
///
/// Route path: `/add-semester`
class AddSemesterPage extends StatelessWidget {
  /// The pre-filled semester name from the [SemesterNameSheet].
  final String semesterName;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Creates an [AddSemesterPage].
  const AddSemesterPage({
    super.key,
    required this.semesterName,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddSemesterBloc>(
      create: (BuildContext ctx) => AddSemesterBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
      )..add(AddSemesterInitialized(name: semesterName, gpaType: gpaType)),
      child: const _AddSemesterView(),
    );
  }
}

/// The inner view for the add-semester screen.
///
/// Uses [BlocConsumer] to both build UI and react to navigation side-effects.
class _AddSemesterView extends StatelessWidget {
  /// Creates an [_AddSemesterView].
  const _AddSemesterView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddSemesterBloc, AddSemesterState>(
      listenWhen: (AddSemesterState prev, AddSemesterState curr) =>
          curr.status != prev.status,
      listener: (BuildContext ctx, AddSemesterState state) {
        if (state.status == AddSemesterStatus.saved) {
          // Refresh the home BLoC before navigating so the dashboard shows
          // the newly added semester immediately.
          ctx.read<HomeBloc>().add(const HomeDataRequested());
          ctx.goNamed(AppRoutes.home);
        } else if (state.status == AddSemesterStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (BuildContext context, AddSemesterState state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                _AddSemesterAppBar(semesterName: state.semesterName),
                BlocBuilder<AddSemesterBloc, AddSemesterState>(
                  buildWhen: (AddSemesterState prev, AddSemesterState curr) =>
                      prev.sgpa != curr.sgpa,
                  builder: (BuildContext _, AddSemesterState s) =>
                      SgpaBar(sgpa: s.sgpa),
                ),
                Expanded(
                  child: _CourseList(state: state),
                ),
                _ConfirmButton(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The custom app bar row for the add-semester screen.
class _AddSemesterAppBar extends StatelessWidget {
  /// The semester name shown as a subtitle.
  final String semesterName;

  /// Creates an [_AddSemesterAppBar].
  const _AddSemesterAppBar({required this.semesterName});

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
                Text('Add Semester', style: AppTypography.titleMedium),
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
          // Placeholder to balance the back button
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// The scrollable list of course entry cards plus the add button.
class _CourseList extends StatelessWidget {
  /// The current add-semester state.
  final AddSemesterState state;

  /// Creates a [_CourseList].
  const _CourseList({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // "Courses · N" section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space20,
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
                  gpaType: state.gpaType,
                  onChanged: (Subject updated) => context
                      .read<AddSemesterBloc>()
                      .add(CourseUpdated(index: index, subject: updated)),
                  onDelete: () => context
                      .read<AddSemesterBloc>()
                      .add(CourseDeleted(index)),
                ),
              );
            },
            childCount: state.subjects.length,
          ),
        ),
        // "+ Add Another Course" dashed button
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
                  context.read<AddSemesterBloc>().add(const CourseAdded()),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.space16)),
      ],
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
          border: Border.all(
            color: AppColors.border,
            width: 1.5,
            // Dashed style approximated with a regular border per design token
            // conventions (no DashedBorder token; consistent with onboarding).
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              LucideIcons.plus,
              size: 16,
              color: AppColors.accent,
            ),
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

/// The sticky bottom "Confirm" button bar.
class _ConfirmButton extends StatelessWidget {
  /// The current add-semester state.
  final AddSemesterState state;

  /// Creates a [_ConfirmButton].
  const _ConfirmButton({required this.state});

  @override
  Widget build(BuildContext context) {
    final bool isSaving = state.status == AddSemesterStatus.saving;

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
          onPressed: isSaving
              ? null
              : () => context
                  .read<AddSemesterBloc>()
                  .add(const SemesterConfirmed()),
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
          label: const Text('Confirm'),
          iconAlignment: IconAlignment.end,
        ),
      ),
    );
  }
}
