import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/features/semester_detail/presentation/bloc/semester_detail_bloc.dart';
import 'package:gpa_cal/features/semester_detail/presentation/bloc/semester_detail_event.dart';
import 'package:gpa_cal/features/semester_detail/presentation/bloc/semester_detail_state.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The screen displaying a single semester's SGPA and course breakdown.
///
/// Accepts [semesterHash] from the route path parameter and [gpaType] from
/// route extras. Provides a scoped [SemesterDetailBloc] and handles loading,
/// error, and success states.
///
/// Route path: `/semester-detail/:hash`
class SemesterDetailPage extends StatelessWidget {
  /// The unique hash of the semester to display.
  final int semesterHash;

  /// The GPA scale type forwarded to the edit-semester route.
  ///
  /// `0` = 4.0 scale (default), `1` = 4.2 scale.
  final int gpaType;

  /// Creates a [SemesterDetailPage].
  const SemesterDetailPage({
    super.key,
    required this.semesterHash,
    this.gpaType = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SemesterDetailBloc>(
      create: (BuildContext ctx) => SemesterDetailBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
      )..add(SemesterDetailRequested(semesterHash)),
      child: _SemesterDetailView(semesterHash: semesterHash, gpaType: gpaType),
    );
  }
}

/// The inner view that observes [SemesterDetailBloc] state.
class _SemesterDetailView extends StatelessWidget {
  /// The hash forwarded to the edit-semester route.
  final int semesterHash;

  /// The GPA scale type forwarded to the edit-semester route.
  final int gpaType;

  /// Creates a [_SemesterDetailView].
  const _SemesterDetailView({
    required this.semesterHash,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<SemesterDetailBloc, SemesterDetailState>(
          builder: (BuildContext context, SemesterDetailState state) {
            return switch (state.status) {
              SemesterDetailStatus.initial ||
              SemesterDetailStatus.loading =>
                const _LoadingView(),
              SemesterDetailStatus.error =>
                _ErrorView(message: state.errorMessage, hash: semesterHash),
              SemesterDetailStatus.success =>
                _ContentView(semester: state.semester!, gpaType: gpaType),
            };
          },
        ),
      ),
    );
  }
}

/// Shown while the semester is loading.
class _LoadingView extends StatelessWidget {
  /// Creates a [_LoadingView].
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.accent,
        strokeWidth: 2,
      ),
    );
  }
}

/// Shown when loading fails.
class _ErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// The semester hash for retrying the load.
  final int hash;

  /// Creates an [_ErrorView].
  const _ErrorView({required this.message, required this.hash});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DetailAppBar(semesterName: ''),
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
                    message.isNotEmpty ? message : 'Something went wrong.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space24),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<SemesterDetailBloc>()
                        .add(SemesterDetailRequested(hash)),
                    icon: const Icon(LucideIcons.refreshCw, size: 16),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shown when the semester loaded successfully.
class _ContentView extends StatelessWidget {
  /// The loaded semester to display.
  final Semester semester;

  /// The GPA scale type forwarded to the edit route.
  final int gpaType;

  /// Creates a [_ContentView].
  const _ContentView({required this.semester, required this.gpaType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _DetailAppBar(semesterName: semester.name),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SgpaHero(semester: semester),
                const SizedBox(height: AppSpacing.space32),
                _CoursesCard(semester: semester),
                const SizedBox(height: AppSpacing.space12),
                _TotalCreditsRow(totalCredit: semester.totalCredit),
                const SizedBox(height: AppSpacing.space32),
                _EditButton(semester: semester, gpaType: gpaType),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// The custom app bar for the detail screen with a back button.
class _DetailAppBar extends StatelessWidget {
  /// The semester name shown as the centered title.
  final String semesterName;

  /// Creates a [_DetailAppBar].
  const _DetailAppBar({required this.semesterName});

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
            child: Text(
              semesterName,
              style: AppTypography.titleMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

/// The SGPA hero section for the semester detail screen.
class _SgpaHero extends StatelessWidget {
  /// The semester whose SGPA and metadata are displayed.
  final Semester semester;

  /// Creates an [_SgpaHero].
  const _SgpaHero({required this.semester});

  @override
  Widget build(BuildContext context) {
    final int courseCount = semester.subjectList.length;
    final String creditStr = semester.totalCredit == semester.totalCredit.truncateToDouble()
        ? semester.totalCredit.toInt().toString()
        : semester.totalCredit.toStringAsFixed(1);

    return Column(
      children: [
        Text(
          'Semester GPA',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.02 * 12,
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              semester.sgpa.toStringAsFixed(2),
              style: GoogleFonts.interTight(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.gpa,
                height: 1.0,
                letterSpacing: -0.02 * 40,
              ),
            ),
            const SizedBox(width: AppSpacing.space4),
            Text(
              '/ 4.0',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPlaceholder,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          '$courseCount ${courseCount == 1 ? 'course' : 'courses'} · $creditStr credits',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// A card containing the list of courses with dividers.
class _CoursesCard extends StatelessWidget {
  /// The semester whose subjects are displayed.
  final Semester semester;

  /// Creates a [_CoursesCard].
  const _CoursesCard({required this.semester});

  @override
  Widget build(BuildContext context) {
    final List<Subject> subjects = semester.subjectList;

    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.cardPadding,
              AppSpacing.space8,
            ),
            child: Text(
              'Courses',
              style: AppTypography.titleMedium,
            ),
          ),
          const Divider(height: 1, indent: 0, endIndent: 0),
          ...List.generate(subjects.length, (int index) {
            final Subject subject = subjects[index];
            return Column(
              children: [
                _CourseRow(subject: subject),
                if (index < subjects.length - 1)
                  const Divider(
                    height: 1,
                    indent: AppSpacing.cardPadding,
                    endIndent: 0,
                    color: AppColors.border,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// A single row in the courses card showing a subject's name, grade, and point.
class _CourseRow extends StatelessWidget {
  /// The subject to display.
  final Subject subject;

  /// Creates a [_CourseRow].
  const _CourseRow({required this.subject});

  /// Returns the badge background color for the given [grade].
  Color _badgeBackground(String grade) {
    if (grade == 'A+' || grade == 'A' || grade == 'A-') {
      return AppColors.accentTint;
    }
    if (grade == 'B+' || grade == 'B' || grade == 'B-') {
      return AppColors.warningTint;
    }
    if (grade == 'C+' || grade == 'C' || grade == 'C-') {
      return AppColors.surfaceMuted;
    }
    return AppColors.errorTint;
  }

  /// Returns the badge text color for the given [grade].
  Color _badgeTextColor(String grade) {
    if (grade == 'A+' || grade == 'A' || grade == 'A-') {
      return AppColors.accent;
    }
    if (grade == 'B+' || grade == 'B' || grade == 'B-') {
      return AppColors.gpa;
    }
    if (grade == 'C+' || grade == 'C' || grade == 'C-') {
      return AppColors.textSecondary;
    }
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.cardPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                subject.courseName.isEmpty ? 'Untitled Course' : subject.courseName,
                style: AppTypography.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            // Grade badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space8,
                vertical: AppSpacing.space4,
              ),
              decoration: BoxDecoration(
                color: _badgeBackground(subject.grade),
                borderRadius: AppSpacing.borderRadiusSmall,
              ),
              child: Text(
                subject.grade,
                style: AppTypography.labelSmall.copyWith(
                  color: _badgeTextColor(subject.grade),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.space8),
            // Grade point value
            SizedBox(
              width: 48,
              child: Text(
                subject.credit.toStringAsFixed(1),
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.gpa,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A row below the courses card showing the total credit hours.
class _TotalCreditsRow extends StatelessWidget {
  /// The total credit hours for this semester.
  final double totalCredit;

  /// Creates a [_TotalCreditsRow].
  const _TotalCreditsRow({required this.totalCredit});

  @override
  Widget build(BuildContext context) {
    final String creditStr = totalCredit == totalCredit.truncateToDouble()
        ? totalCredit.toInt().toString()
        : totalCredit.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Credits',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            creditStr,
            style: AppTypography.labelLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// The full-width "Edit Semester" button at the bottom of the detail screen.
class _EditButton extends StatelessWidget {
  /// The semester used to derive the navigation hash.
  final Semester semester;

  /// The GPA scale type forwarded to the edit route.
  final int gpaType;

  /// Creates an [_EditButton].
  const _EditButton({required this.semester, required this.gpaType});

  /// Navigates to the edit screen and reloads data on return.
  Future<void> _navigateToEdit(BuildContext context) async {
    await context.pushNamed(
      AppRoutes.editSemester,
      pathParameters: {'hash': '${semester.hash}'},
      extra: {'gpaType': gpaType},
    );
    if (!context.mounted) return;
    context
        .read<SemesterDetailBloc>()
        .add(SemesterDetailRequested(semester.hash));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _navigateToEdit(context),
        icon: const Icon(LucideIcons.pencil),
        label: const Text('Edit Semester'),
        iconAlignment: IconAlignment.start,
      ),
    );
  }
}
