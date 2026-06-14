import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/features/what_if/presentation/bloc/what_if_bloc.dart';
import 'package:gpa_cal/features/what_if/presentation/bloc/what_if_event.dart';
import 'package:gpa_cal/features/what_if/presentation/bloc/what_if_state.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_decorations.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The What-If Calculator screen.
///
/// Allows the user to set a target CGPA and configure the next semester's
/// course count and credits, then see the required average grade to achieve
/// that target. Provides a [BlocProvider] scoped to this route.
///
/// Route path: `/what-if`
class WhatIfPage extends StatelessWidget {
  /// Creates a [WhatIfPage].
  const WhatIfPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WhatIfBloc>(
      create: (BuildContext ctx) => WhatIfBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
        userDetailsRepository: ctx.read<UserDetailsRepository>(),
      )..add(const WhatIfInitialized()),
      child: const _WhatIfView(),
    );
  }
}

/// The inner view that observes [WhatIfBloc] and renders the calculator UI.
class _WhatIfView extends StatelessWidget {
  /// Creates a [_WhatIfView].
  const _WhatIfView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, size: 20),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
        title: Text('What-If Calculator', style: AppTypography.titleLarge),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: const Divider(height: 1, indent: 0, endIndent: 0),
        ),
      ),
      body: BlocBuilder<WhatIfBloc, WhatIfState>(
        builder: (BuildContext context, WhatIfState state) {
          return switch (state.status) {
            WhatIfStatus.initial || WhatIfStatus.loading =>
              const _WhatIfLoadingView(),
            WhatIfStatus.error =>
              _WhatIfErrorView(message: state.errorMessage),
            _ => _WhatIfCalculatorView(state: state),
          };
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Loading
// ---------------------------------------------------------------------------

/// Shown while the calculator initialises.
class _WhatIfLoadingView extends StatelessWidget {
  /// Creates a [_WhatIfLoadingView].
  const _WhatIfLoadingView();

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

// ---------------------------------------------------------------------------
// Error
// ---------------------------------------------------------------------------

/// Shown when initialisation fails.
class _WhatIfErrorView extends StatelessWidget {
  /// The error message to display.
  final String message;

  /// Creates a [_WhatIfErrorView].
  const _WhatIfErrorView({required this.message});

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
                  context.read<WhatIfBloc>().add(const WhatIfInitialized()),
              icon: const Icon(LucideIcons.refreshCw, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(elevation: 0),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calculator view
// ---------------------------------------------------------------------------

/// The main calculator UI — shown in [WhatIfStatus.ready], [calculated],
/// and [impossible] states.
class _WhatIfCalculatorView extends StatelessWidget {
  /// The current what-if state.
  final WhatIfState state;

  /// Creates a [_WhatIfCalculatorView].
  const _WhatIfCalculatorView({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.space24,
        AppSpacing.screenPadding,
        AppSpacing.space48,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current GPA card
          _CurrentStateCard(state: state),
          const SizedBox(height: AppSpacing.space20),

          // Target CGPA input
          _TargetCgpaInput(
            gpaType: state.gpaType,
            initialValue:
                state.targetCgpa > 0 ? state.targetCgpa.toStringAsFixed(2) : '',
          ),
          const SizedBox(height: AppSpacing.space24),

          // Next semester section
          Text('Next Semester', style: AppTypography.headlineMedium),
          const SizedBox(height: AppSpacing.space16),

          // Number of courses
          _CoursesRow(numCourses: state.numCourses),
          const SizedBox(height: AppSpacing.space16),

          // Credits per course
          _CreditsRow(creditsPerCourse: state.creditsPerCourse),
          const SizedBox(height: AppSpacing.space24),

          // Result card
          _ResultCard(state: state),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Current state card
// ---------------------------------------------------------------------------

/// Displays the user's current CGPA, scale, and total credits.
class _CurrentStateCard extends StatelessWidget {
  /// The current what-if state.
  final WhatIfState state;

  /// Creates a [_CurrentStateCard].
  const _CurrentStateCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final String scaleSuffix = state.gpaType == 1 ? '/ 4.2' : '/ 4.0';

    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YOUR CURRENT GPA',
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
                  state.currentCgpa.toStringAsFixed(2),
                  style: AppTypography.displayLarge.copyWith(
                    color: AppColors.gpa,
                    fontSize: 40,
                  ),
                ),
                const SizedBox(width: AppSpacing.space8),
                Text(
                  scaleSuffix,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPlaceholder,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space12,
                    vertical: AppSpacing.space4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: AppSpacing.borderRadiusSmall,
                  ),
                  child: Text(
                    '${state.currentTotalCredit.toInt()} credits',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Target CGPA input
// ---------------------------------------------------------------------------

/// A text field for entering the target CGPA.
///
/// Dispatches [TargetCgpaChanged] on valid input changes.
class _TargetCgpaInput extends StatefulWidget {
  /// The GPA scale type for range validation.
  final int gpaType;

  /// The initial text value to pre-fill (empty string = no value).
  final String initialValue;

  /// Creates a [_TargetCgpaInput].
  const _TargetCgpaInput({
    required this.gpaType,
    required this.initialValue,
  });

  @override
  State<_TargetCgpaInput> createState() => _TargetCgpaInputState();
}

class _TargetCgpaInputState extends State<_TargetCgpaInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Returns the max GPA value for the chosen scale.
  double get _maxGpa => widget.gpaType == 1 ? 4.2 : 4.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Target CGPA', style: AppTypography.headlineMedium),
        const SizedBox(height: AppSpacing.space12),
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
            controller: _controller,
            focusNode: _focusNode,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            style: AppTypography.titleLarge,
            decoration: InputDecoration(
              hintText: '0.00 – ${_maxGpa.toStringAsFixed(1)}',
              hintStyle: AppTypography.titleLarge.copyWith(
                color: AppColors.textPlaceholder,
              ),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (String value) {
              final double? parsed = double.tryParse(value);
              if (parsed != null && parsed >= 0 && parsed <= _maxGpa) {
                context.read<WhatIfBloc>().add(TargetCgpaChanged(parsed));
              } else if (value.isEmpty) {
                context.read<WhatIfBloc>().add(const TargetCgpaChanged(0.0));
              }
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Number of courses row
// ---------------------------------------------------------------------------

/// A row displaying the "Number of Courses" label with an integer stepper (1–8).
class _CoursesRow extends StatelessWidget {
  /// The current number of courses.
  final int numCourses;

  /// Creates a [_CoursesRow].
  const _CoursesRow({required this.numCourses});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Number of Courses', style: AppTypography.titleMedium),
                  Text(
                    'How many courses next semester?',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _IntegerStepper(
              value: numCourses,
              min: 1,
              max: 8,
              onChanged: (int value) =>
                  context.read<WhatIfBloc>().add(NumCoursesChanged(value)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Credits per course row
// ---------------------------------------------------------------------------

/// A row displaying the "Credits per Course" label with a [CreditStepper].
class _CreditsRow extends StatelessWidget {
  /// The current credits-per-course value.
  final double creditsPerCourse;

  /// Creates a [_CreditsRow].
  const _CreditsRow({required this.creditsPerCourse});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Credits per Course', style: AppTypography.titleMedium),
                  Text(
                    'Credit hours for each course',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            CreditStepper(
              value: creditsPerCourse,
              min: 0.5,
              max: 10,
              step: 0.5,
              onChanged: (double value) => context
                  .read<WhatIfBloc>()
                  .add(CreditsPerCourseChanged(value)),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Integer stepper
// ---------------------------------------------------------------------------

/// A compact minus/value/plus stepper for integer values.
///
/// Used for the "Number of Courses" control. Similar to [CreditStepper]
/// but works with [int] values.
class _IntegerStepper extends StatelessWidget {
  /// The current integer value.
  final int value;

  /// The minimum selectable value.
  final int min;

  /// The maximum selectable value.
  final int max;

  /// Called when the value changes.
  final ValueChanged<int> onChanged;

  /// Creates an [_IntegerStepper].
  const _IntegerStepper({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppSpacing.borderRadiusMedium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: LucideIcons.minus,
            enabled: value > min,
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 36,
            child: Center(
              child: Text(
                '$value',
                style: AppTypography.headlineMedium.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          _StepButton(
            icon: LucideIcons.plus,
            enabled: value < max,
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

/// A small icon button used inside [_IntegerStepper].
class _StepButton extends StatelessWidget {
  /// The icon to display.
  final IconData icon;

  /// Whether the button is enabled.
  final bool enabled;

  /// Called when the button is tapped.
  final VoidCallback? onTap;

  /// Creates a [_StepButton].
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppSpacing.borderRadiusMedium.subtract(
            const BorderRadius.all(Radius.circular(2)),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.textPrimary : AppColors.disabled,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Result card
// ---------------------------------------------------------------------------

/// Displays the what-if calculation result.
///
/// Shows different content depending on the current [WhatIfStatus]:
/// - [WhatIfStatus.ready]: prompt the user to enter a target GPA.
/// - [WhatIfStatus.calculated]: the required average grade.
/// - [WhatIfStatus.impossible]: an explanation that the target cannot be met.
class _ResultCard extends StatelessWidget {
  /// The current what-if state.
  final WhatIfState state;

  /// Creates a [_ResultCard].
  const _ResultCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.space20),
        child: _buildContent(),
      ),
    );
  }

  /// Builds the card body based on the current status.
  Widget _buildContent() {
    if (state.status == WhatIfStatus.calculated && state.result != null) {
      return _AchievableResult(result: state.result!);
    }

    if (state.status == WhatIfStatus.impossible) {
      return _ImpossibleResult(
        currentCgpa: state.currentCgpa,
        gpaType: state.gpaType,
      );
    }

    return _ResultPlaceholder();
  }
}

/// The result content shown when the target is achievable.
class _AchievableResult extends StatelessWidget {
  /// The calculated what-if result.
  final WhatIfResult result;

  /// Creates an [_AchievableResult].
  const _AchievableResult({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You need an average grade of:',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              result.requiredGradeLabel,
              style: AppTypography.headlineLarge.copyWith(
                color: AppColors.gpa,
                fontSize: 40,
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Text(
              '(${result.requiredGradePoint.toStringAsFixed(2)} pts)',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'This is the minimum average you need across all courses in your next semester.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// The result content shown when the target cannot be achieved.
class _ImpossibleResult extends StatelessWidget {
  /// The user's current CGPA.
  final double currentCgpa;

  /// The GPA scale type.
  final int gpaType;

  /// Creates an [_ImpossibleResult].
  const _ImpossibleResult({
    required this.currentCgpa,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    final String maxGpa = gpaType == 1 ? '4.2' : '4.0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              LucideIcons.xCircle,
              size: 20,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: Text(
                'Target is not achievable in one semester',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'Even with straight A+ grades (${maxGpa} pts per course), '
          'you cannot reach that target in a single semester. '
          'Try a lower target or add more semesters.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// A placeholder shown before any calculation has been performed.
class _ResultPlaceholder extends StatelessWidget {
  /// Creates a [_ResultPlaceholder].
  _ResultPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          LucideIcons.calculator,
          size: 20,
          color: AppColors.textPlaceholder,
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Text(
            'Enter your target GPA above to see what you need.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
