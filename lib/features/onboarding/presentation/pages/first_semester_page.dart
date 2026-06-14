import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/core/utils/gpa_calculator.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The first semester entry screen (Step 2 of 2) in the onboarding flow.
///
/// Reads the [OnboardingBloc] provided by the app root. Manages local course
/// list and semester name state with [StatefulWidget], then dispatches
/// [FirstSemesterSubmitted] to the bloc on completion.
///
/// A [BlocListener] watches for [OnboardingStatus.success] from the
/// [FirstSemesterSubmitted] handler and navigates to home.
///
/// Route path: `/first-semester`
class FirstSemesterPage extends StatelessWidget {
  /// Creates a [FirstSemesterPage].
  const FirstSemesterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          current.status != previous.status,
      listener: (BuildContext ctx, OnboardingState state) {
        if (state.status == OnboardingStatus.success) {
          ctx.goNamed(AppRoutes.home);
        } else if (state.status == OnboardingStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: const _FirstSemesterView(),
    );
  }
}

/// The stateful inner view that manages the local course list and semester name.
class _FirstSemesterView extends StatefulWidget {
  /// Creates a [_FirstSemesterView].
  const _FirstSemesterView();

  @override
  State<_FirstSemesterView> createState() => _FirstSemesterViewState();
}

class _FirstSemesterViewState extends State<_FirstSemesterView> {
  /// The semester name entered by the user.
  String _semesterName = 'Semester 1';

  /// The list of courses being built for the first semester.
  ///
  /// Starts with one blank course pre-filled with A+ grade and 3.0 credits.
  late List<Subject> _subjects;

  /// Controller for the semester name field.
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _subjects = [
      const Subject(courseName: '', grade: 'A+', credit: 3.0),
    ];
    _nameController = TextEditingController(text: _semesterName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  /// Calculates the live SGPA for the current subject list and GPA type.
  double _calculateSgpa(int gpaType) {
    return GpaCalculator.calculateSgpa(
      subjects: _subjects,
      gpaType: gpaType,
    );
  }

  /// Replaces the subject at [index] with [subject].
  void _updateSubject(int index, Subject subject) {
    setState(() {
      _subjects = List.of(_subjects)..[index] = subject;
    });
  }

  /// Removes the subject at [index].
  void _deleteSubject(int index) {
    setState(() {
      _subjects = List.of(_subjects)..removeAt(index);
    });
  }

  /// Appends a new blank subject to the list.
  void _addSubject() {
    setState(() {
      _subjects = List.of(_subjects)
        ..add(const Subject(courseName: '', grade: 'A+', credit: 3.0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          buildWhen: (OnboardingState prev, OnboardingState curr) =>
              prev.gpaType != curr.gpaType || prev.status != curr.status,
          builder: (BuildContext ctx, OnboardingState state) {
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Header section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPadding,
                            vertical: AppSpacing.space24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const StepIndicator(
                                currentStep: 2,
                                totalSteps: 2,
                              ),
                              const SizedBox(height: AppSpacing.space32),
                              Text(
                                'Your First Semester',
                                style: AppTypography.headlineLarge,
                              ),
                              const SizedBox(height: AppSpacing.space8),
                              Text(
                                'Name your semester and add your courses to see your SGPA.',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.space24),
                              // Semester name field
                              TextField(
                                key: const Key('first_semester_name'),
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                style: AppTypography.bodyMedium,
                                decoration: const InputDecoration(
                                  labelText: 'SEMESTER NAME',
                                ),
                                onChanged: (String value) {
                                  setState(() => _semesterName = value);
                                },
                              ),
                              const SizedBox(height: AppSpacing.space24),
                              // Courses section header
                              _CourseSectionHeader(
                                courseCount: _subjects.length,
                                sgpa: _calculateSgpa(state.gpaType),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Course cards
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext _, int index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.screenPadding,
                                0,
                                AppSpacing.screenPadding,
                                AppSpacing.space12,
                              ),
                              child: CourseEntryCard(
                                key: ValueKey<int>(index),
                                subject: _subjects[index],
                                index: index,
                                canDelete: _subjects.length > 1,
                                gpaType: state.gpaType,
                                onChanged: (Subject updated) =>
                                    _updateSubject(index, updated),
                                onDelete: () => _deleteSubject(index),
                              ),
                            );
                          },
                          childCount: _subjects.length,
                        ),
                      ),
                      // Add course button
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            0,
                            AppSpacing.screenPadding,
                            AppSpacing.space12,
                          ),
                          child: _AddCourseButton(onTap: _addSubject),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom action bar
                _FirstSemesterActions(
                  subjects: _subjects,
                  semesterName: _semesterName,
                  isLoading: state.status == OnboardingStatus.loading,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Section header showing the course count and a live SGPA pill.
class _CourseSectionHeader extends StatelessWidget {
  /// The number of courses currently in the list.
  final int courseCount;

  /// The live SGPA value computed from the current subject list.
  final double sgpa;

  /// Creates a [_CourseSectionHeader].
  const _CourseSectionHeader({
    required this.courseCount,
    required this.sgpa,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Courses · $courseCount',
          style: AppTypography.titleMedium,
        ),
        const Spacer(),
        // Live SGPA pill
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space12,
            vertical: AppSpacing.space4,
          ),
          decoration: BoxDecoration(
            color: AppColors.warningTint,
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SGPA  ',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                sgpa.toStringAsFixed(2),
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.gpa,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A button for adding another course to the list, rendered with a border outline.
class _AddCourseButton extends StatelessWidget {
  /// Called when the user taps to add a course.
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

/// The bottom action bar with "Finish Setup" and "Back" controls.
class _FirstSemesterActions extends StatelessWidget {
  /// The current list of subjects to submit.
  final List<Subject> subjects;

  /// The current semester name to submit.
  final String semesterName;

  /// Whether a submission is in progress (disables the button).
  final bool isLoading;

  /// Creates a [_FirstSemesterActions].
  const _FirstSemesterActions({
    required this.subjects,
    required this.semesterName,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.space16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          const SizedBox(height: AppSpacing.space16),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () => context.read<OnboardingBloc>().add(
                        FirstSemesterSubmitted(
                          semesterName: semesterName,
                          subjects: subjects,
                        ),
                      ),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.surface,
                      ),
                    )
                  : const Icon(LucideIcons.chevronRight, size: 18),
              label: const Text('Finish Setup'),
              iconAlignment: IconAlignment.end,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft,
                color: AppColors.textSecondary),
            label: const Text('Back'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
