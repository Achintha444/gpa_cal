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
/// Allows the user to set a target CGPA, specify the number of remaining
/// semesters and total remaining credits, then see the required average
/// grade to achieve that target. Provides a [BlocProvider] scoped to this
/// route.
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, indent: 0, endIndent: 0),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
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
/// [alreadyAchieved], and [impossible] states.
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
          _CurrentGpaCard(state: state),
          const SizedBox(height: AppSpacing.space20),

          // Target CGPA section
          Text('Target CGPA', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.space12),
          _TargetCgpaInput(
            gpaType: state.gpaType,
            initialValue: state.targetCgpa > 0
                ? state.targetCgpa.toStringAsFixed(2)
                : '',
          ),
          const SizedBox(height: AppSpacing.space24),

          // Remaining plan section
          Text('Remaining Plan', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.space12),
          _RemainingPlanCard(state: state),
          const SizedBox(height: AppSpacing.space24),

          // Result card
          _ResultCard(state: state),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Current GPA card
// ---------------------------------------------------------------------------

/// Displays the user's current CGPA, scale, and total credits earned.
class _CurrentGpaCard extends StatelessWidget {
  /// The current what-if state.
  final WhatIfState state;

  /// Creates a [_CurrentGpaCard].
  const _CurrentGpaCard({required this.state});

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
                _CreditsBadge(
                  credits: state.currentTotalCredit.toInt(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A small pill badge showing the total earned credits.
class _CreditsBadge extends StatelessWidget {
  /// The total credits earned so far.
  final int credits;

  /// Creates a [_CreditsBadge].
  const _CreditsBadge({required this.credits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppSpacing.borderRadiusSmall,
      ),
      child: Text(
        '$credits credits',
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
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
/// Uses the theme's [InputDecoration] (filled, no border at rest, accent
/// border on focus) without any additional wrapping container to avoid the
/// double-border bug. Dispatches [TargetCgpaChanged] on every change.
class _TargetCgpaInput extends StatefulWidget {
  /// The GPA scale type for range validation hint text.
  final int gpaType;

  /// The initial text value to pre-fill. Empty string means no value.
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Returns the max GPA label for the placeholder text.
  String get _maxGpaLabel => widget.gpaType == 1 ? '4.2' : '4.0';

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: AppTypography.titleLarge,
      decoration: InputDecoration(
        hintText: 'e.g. 3.50',
        hintStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPlaceholder,
        ),
        helperText: '0.00 – $_maxGpaLabel',
        helperStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textPlaceholder,
        ),
      ),
      onChanged: (String value) {
        context.read<WhatIfBloc>().add(TargetCgpaChanged(value));
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Remaining plan card
// ---------------------------------------------------------------------------

/// A card containing two rows: remaining semesters and total remaining credits.
///
/// The remaining semesters row has a compact 80px [TextField] on the right.
/// The total remaining credits row uses a [CreditStepper].
class _RemainingPlanCard extends StatelessWidget {
  /// The current what-if state.
  final WhatIfState state;

  /// Creates a [_RemainingPlanCard].
  const _RemainingPlanCard({required this.state});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.cardFlat,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          children: [
            // Row 1: Remaining semesters
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Remaining Semesters',
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                _RemainingSemestersField(
                  initialValue: state.remainingSemesters.toString(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.space16),
            const Divider(height: 1, indent: 0, endIndent: 0),
            const SizedBox(height: AppSpacing.space16),
            // Row 2: Total remaining credits
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Remaining Credits',
                    style: AppTypography.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.space12),
                CreditStepper(
                  value: state.totalRemainingCredits,
                  min: 1,
                  max: 200,
                  step: 1,
                  onChanged: (double value) => context
                      .read<WhatIfBloc>()
                      .add(TotalRemainingCreditsChanged(value)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A compact 80px-wide filled text field for entering remaining semesters.
///
/// Uses the theme's standard filled input style (no manual border).
/// Dispatches [RemainingSemestersChanged] on every change.
class _RemainingSemestersField extends StatefulWidget {
  /// The initial text value.
  final String initialValue;

  /// Creates a [_RemainingSemestersField].
  const _RemainingSemestersField({required this.initialValue});

  @override
  State<_RemainingSemestersField> createState() =>
      _RemainingSemestersFieldState();
}

class _RemainingSemestersFieldState extends State<_RemainingSemestersField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTypography.titleMedium,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: '1',
          hintStyle: AppTypography.titleMedium.copyWith(
            color: AppColors.textPlaceholder,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space8,
            vertical: AppSpacing.space12,
          ),
          isDense: true,
        ),
        onChanged: (String value) {
          context.read<WhatIfBloc>().add(RemainingSemestersChanged(value));
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Result card
// ---------------------------------------------------------------------------

/// Displays the what-if calculation result.
///
/// Shows one of four states based on [WhatIfState.status]:
/// - [WhatIfStatus.ready]: prompt to enter a target GPA.
/// - [WhatIfStatus.calculated]: the required average grade across N semesters.
/// - [WhatIfStatus.alreadyAchieved]: success message.
/// - [WhatIfStatus.impossible]: explanation with the required (out-of-range) point.
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

  /// Builds the card body based on the current calculation status.
  Widget _buildContent() {
    switch (state.status) {
      case WhatIfStatus.calculated:
        if (state.result != null) {
          return _AchievableResult(
            result: state.result!,
            remainingSemesters: state.remainingSemesters,
            totalRemainingCredits: state.totalRemainingCredits,
          );
        }
        return const _ResultPrompt();

      case WhatIfStatus.alreadyAchieved:
        return const _AlreadyAchievedResult();

      case WhatIfStatus.impossible:
        return _ImpossibleResult(
          result: state.result,
          gpaType: state.gpaType,
        );

      default:
        return const _ResultPrompt();
    }
  }
}

/// The result content shown when the target is achievable within the plan.
class _AchievableResult extends StatelessWidget {
  /// The calculated what-if result.
  final WhatIfResult result;

  /// The number of remaining semesters for context display.
  final int remainingSemesters;

  /// The total remaining credits for context display.
  final double totalRemainingCredits;

  /// Creates an [_AchievableResult].
  const _AchievableResult({
    required this.result,
    required this.remainingSemesters,
    required this.totalRemainingCredits,
  });

  /// Formats [totalRemainingCredits] as an integer string when whole, otherwise
  /// as a one-decimal string.
  String _formatCredits(double v) {
    return v == v.truncateToDouble()
        ? v.toInt().toString()
        : v.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final String semesterLabel =
        remainingSemesters == 1 ? 'semester' : 'semesters';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You need an average of',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space8),
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
          'across $remainingSemesters $semesterLabel',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          'with ${_formatCredits(totalRemainingCredits)} total credits',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textPlaceholder,
          ),
        ),
      ],
    );
  }
}

/// The result content shown when the target CGPA is already achieved.
class _AlreadyAchievedResult extends StatelessWidget {
  /// Creates an [_AlreadyAchievedResult].
  const _AlreadyAchievedResult();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          LucideIcons.checkCircle2,
          size: 20,
          color: AppColors.success,
        ),
        const SizedBox(width: AppSpacing.space12),
        Expanded(
          child: Text(
            "You've already achieved this!",
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.success,
            ),
          ),
        ),
      ],
    );
  }
}

/// The result content shown when the target cannot be achieved with the given
/// remaining credits.
class _ImpossibleResult extends StatelessWidget {
  /// The calculation result containing the out-of-range required grade point.
  final WhatIfResult? result;

  /// The GPA scale type.
  final int gpaType;

  /// Creates an [_ImpossibleResult].
  const _ImpossibleResult({
    required this.result,
    required this.gpaType,
  });

  @override
  Widget build(BuildContext context) {
    final String maxGpa = gpaType == 1 ? '4.2' : '4.0';
    final String requiredStr = result != null
        ? result!.requiredGradePoint.toStringAsFixed(2)
        : '—';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              LucideIcons.alertTriangle,
              size: 20,
              color: AppColors.error,
            ),
            const SizedBox(width: AppSpacing.space8),
            Expanded(
              child: Text(
                'Target not achievable',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.space8),
        Text(
          'The required grade point ($requiredStr) exceeds the maximum '
          '($maxGpa). Consider spreading your goal over more semesters '
          'or adjusting your target.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// A placeholder shown before any target has been entered.
class _ResultPrompt extends StatelessWidget {
  /// Creates a [_ResultPrompt].
  const _ResultPrompt();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          LucideIcons.clipboard,
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
