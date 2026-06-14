import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_event.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_state.dart';
import 'package:gpa_cal/features/dashboard/presentation/widgets/semester_name_sheet.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The main home dashboard screen showing CGPA and all semesters.
///
/// Reads the [HomeBloc] provided at the app root level (see `app.dart`).
/// Dispatches [HomeDataRequested] on mount to always show fresh data after
/// any semester mutation. Renders the CGPA hero, semester list, and FAB for
/// adding a new semester. Handles loading, error, empty, and success states.
///
/// Route path: `/home`
class HomePage extends StatefulWidget {
  /// Creates a [HomePage].
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Always reload data when the home screen is mounted. This covers both the
    // initial load and the case where the user navigates back via goNamed(home)
    // after adding or editing a semester.
    context.read<HomeBloc>().add(const HomeDataRequested());
  }

  @override
  Widget build(BuildContext context) {
    return const _HomeView();
  }
}

/// The inner view that observes [HomeBloc] state and renders the home content.
class _HomeView extends StatelessWidget {
  /// Creates a [_HomeView].
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState state) {
            return switch (state.status) {
              HomeStatus.initial || HomeStatus.loading => const _LoadingView(),
              HomeStatus.error => _ErrorView(message: state.errorMessage),
              HomeStatus.empty => _EmptyView(
                  userDetails: state.userDetails,
                  onAddSemester: () => _showSemesterNameSheet(
                    context,
                    gpaType: state.userDetails?.gpaType ?? 0,
                  ),
                ),
              HomeStatus.success => _SuccessView(
                  userResult: state.userResult!,
                  userDetails: state.userDetails!,
                  onAddSemester: () => _showSemesterNameSheet(
                    context,
                    gpaType: state.userDetails?.gpaType ?? 0,
                  ),
                  onSemesterTap: (Semester semester) =>
                      context.pushNamed(
                        AppRoutes.semesterDetail,
                        pathParameters: {'hash': '${semester.hash}'},
                        extra: {'gpaType': state.userDetails?.gpaType ?? 0},
                      ),
                ),
            };
          },
        ),
      ),
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (HomeState prev, HomeState curr) =>
            prev.status != curr.status,
        builder: (BuildContext context, HomeState state) {
          if (state.status == HomeStatus.empty) return const SizedBox.shrink();
          return _HomeFab(
            onTap: () => _showSemesterNameSheet(
              context,
              gpaType: state.userDetails?.gpaType ?? 0,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  /// Shows the [SemesterNameSheet] bottom sheet and navigates to add-semester
  /// with the returned semester name and the user's [gpaType].
  Future<void> _showSemesterNameSheet(
    BuildContext context, {
    required int gpaType,
  }) async {
    final String? name = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const SemesterNameSheet(),
    );

    if (name != null && context.mounted) {
      context.pushNamed(
        AppRoutes.addSemester,
        extra: {'name': name, 'gpaType': gpaType},
      );
    }
  }
}

/// Shown while [HomeStatus.loading] or [HomeStatus.initial].
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

/// Shown when [HomeStatus.error] occurs.
class _ErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Creates an [_ErrorView].
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
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
              onPressed: () =>
                  context.read<HomeBloc>().add(const HomeDataRequested()),
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when [HomeStatus.empty] — no semesters yet.
class _EmptyView extends StatelessWidget {
  /// The user's details for displaying the avatar.
  final UserDetails? userDetails;

  /// Called when the user taps the CTA or FAB to add the first semester.
  final VoidCallback onAddSemester;

  /// Creates an [_EmptyView].
  const _EmptyView({
    required this.userDetails,
    required this.onAddSemester,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.space20,
          ),
          child: _AppBarRow(userDetails: userDetails),
        ),
        const Divider(height: 1, indent: 0, endIndent: 0),
        Expanded(
          child: EmptyStateView(
            icon: LucideIcons.graduationCap,
            headline: 'Start tracking your GPA',
            body: 'Your academic journey begins with one semester.',
            ctaLabel: 'Add Your First Semester',
            onCtaTap: onAddSemester,
          ),
        ),
      ],
    );
  }
}

/// Shown when [HomeStatus.success] — semesters exist.
class _SuccessView extends StatelessWidget {
  /// The full user result containing CGPA and all semesters.
  final UserResult userResult;

  /// The user's profile details.
  final UserDetails userDetails;

  /// Called when the user taps the FAB to add a new semester.
  final VoidCallback onAddSemester;

  /// Called when the user taps a semester card.
  final ValueChanged<Semester> onSemesterTap;

  /// Creates a [_SuccessView].
  const _SuccessView({
    required this.userResult,
    required this.userDetails,
    required this.onAddSemester,
    required this.onSemesterTap,
  });

  @override
  Widget build(BuildContext context) {
    // Render semesters most-recent first.
    final List<Semester> semesters =
        List.of(userResult.semesters).reversed.toList();

    return CustomScrollView(
      slivers: [
        // App bar area
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.space20,
            ),
            child: _AppBarRow(userDetails: userDetails),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(height: 1, indent: 0, endIndent: 0),
        ),
        // CGPA hero
        SliverToBoxAdapter(
          child: _CgpaHero(
            userResult: userResult,
            gpaType: userDetails.gpaType,
            semesterCount: semesters.length,
          ),
        ),
        // Section header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.space32,
              AppSpacing.screenPadding,
              AppSpacing.space16,
            ),
            child: _SemestersHeader(count: semesters.length),
          ),
        ),
        // Semester cards
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext _, int index) {
              final Semester semester = semesters[index];
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  index < semesters.length - 1 ? AppSpacing.space12 : 0,
                ),
                child: SemesterCard(
                  semester: semester,
                  onTap: () => onSemesterTap(semester),
                ),
              );
            },
            childCount: semesters.length,
          ),
        ),
        // Bottom padding for FAB clearance
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.space64 + AppSpacing.space32),
        ),
      ],
    );
  }
}

/// The app bar row with the "GPA Cal" title and user initials avatar.
class _AppBarRow extends StatelessWidget {
  /// The user's details used to derive the avatar initials.
  final UserDetails? userDetails;

  /// Creates an [_AppBarRow].
  const _AppBarRow({required this.userDetails});

  /// Extracts up to 2 initials from the user's name.
  String _initials(String name) {
    final List<String> parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String initials =
        userDetails != null ? _initials(userDetails!.name) : '?';

    return Row(
      children: [
        Expanded(
          child: Text('GPA Cal', style: AppTypography.headlineLarge),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surfaceMuted,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initials,
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The CGPA hero section displaying the cumulative GPA number with trend pill.
class _CgpaHero extends StatelessWidget {
  /// The user's cumulative result data.
  final UserResult userResult;

  /// The GPA scale type: `0` for 4.0, `1` for 4.2.
  final int gpaType;

  /// The total number of semesters (used to show/hide the trend pill).
  final int semesterCount;

  /// Creates a [_CgpaHero].
  const _CgpaHero({
    required this.userResult,
    required this.gpaType,
    required this.semesterCount,
  });

  /// Formats a GPA value to two decimal places.
  String _formatGpa(double value) => value.toStringAsFixed(2);

  /// Returns the GPA scale denominator string ("/ 4.0" or "/ 4.2").
  String get _scaleSuffix => gpaType == 1 ? '/ 4.2' : '/ 4.0';

  /// Returns `true` if the CGPA is non-zero.
  bool get _hasGpa => userResult.cgpa > 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.space32,
        AppSpacing.screenPadding,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CUMULATIVE GPA',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.08 * 12,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _formatGpa(userResult.cgpa),
                style: GoogleFonts.interTight(
                  fontSize: 52,
                  fontWeight: FontWeight.w700,
                  color: _hasGpa ? AppColors.gpa : AppColors.disabled,
                  height: 1.0,
                  letterSpacing: -0.02 * 52,
                ),
              ),
              const SizedBox(width: AppSpacing.space8),
              Text(
                _scaleSuffix,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPlaceholder,
                ),
              ),
              if (semesterCount > 1) ...[
                const Spacer(),
                _TrendPill(semesters: userResult.semesters),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A pill showing the GPA trend between the two most recent semesters.
class _TrendPill extends StatelessWidget {
  /// The full list of semesters, ordered oldest to newest.
  final List<Semester> semesters;

  /// Creates a [_TrendPill].
  const _TrendPill({required this.semesters});

  @override
  Widget build(BuildContext context) {
    final Semester latest = semesters.last;
    final Semester previous = semesters[semesters.length - 2];
    final double delta = latest.sgpa - previous.sgpa;
    final bool positive = delta >= 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: positive ? AppColors.successTint : AppColors.errorFeedbackTint,
        borderRadius: AppSpacing.borderRadiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            positive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
            size: 14,
            color: positive ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: AppSpacing.space4),
          Text(
            '${positive ? '+' : ''}${delta.toStringAsFixed(2)}',
            style: AppTypography.labelMedium.copyWith(
              color: positive ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// The "Semesters · N" section header with count badge.
class _SemestersHeader extends StatelessWidget {
  /// The number of semesters to display in the badge.
  final int count;

  /// Creates a [_SemestersHeader].
  const _SemestersHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Semesters', style: AppTypography.headlineMedium),
        const SizedBox(width: AppSpacing.space8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space8,
            vertical: AppSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: AppSpacing.borderRadiusSmall,
          ),
          child: Text(
            '$count',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// The circular FAB for adding a new semester.
class _HomeFab extends StatelessWidget {
  /// Called when the FAB is tapped.
  final VoidCallback onTap;

  /// Creates a [_HomeFab].
  const _HomeFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: AppSpacing.borderRadiusLarge,
          boxShadow: AppDecorations.elevation2,
        ),
        child: const Icon(
          LucideIcons.plus,
          size: 24,
          color: AppColors.surface,
        ),
      ),
    );
  }
}
