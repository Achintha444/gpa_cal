import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:gpa_cal/shared/widgets.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// The profile setup screen (Step 1 of 2) in the onboarding flow.
///
/// Reads the [OnboardingBloc] provided by the app root — the bloc lives at
/// the app level so state persists across the profile-setup → first-semester
/// navigation (which replaces the route stack via [GoRouter.goNamed]).
///
/// Collects the user's name, university, and GPA scale preference. The
/// "Continue" button is disabled until both name and university are non-empty.
///
/// A [BlocListener] watches for [OnboardingStatus.success] from the
/// [ProfileSubmitted] handler and navigates to the first semester screen.
///
/// Route path: `/profile-setup`
class ProfileSetupPage extends StatelessWidget {
  /// Creates a [ProfileSetupPage].
  const ProfileSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileSetupView();
  }
}

/// The internal view that renders the profile setup form and handles navigation.
class _ProfileSetupView extends StatelessWidget {
  /// Creates a [_ProfileSetupView].
  const _ProfileSetupView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (OnboardingState previous, OnboardingState current) =>
          current.status != previous.status,
      listener: (BuildContext ctx, OnboardingState state) {
        if (state.status == OnboardingStatus.success) {
          ctx.goNamed(AppRoutes.firstSemester);
        } else if (state.status == OnboardingStatus.error &&
            state.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                    vertical: AppSpacing.space24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const StepIndicator(currentStep: 1, totalSteps: 2),
                      const SizedBox(height: AppSpacing.space32),
                      Text('About You', style: AppTypography.headlineLarge),
                      const SizedBox(height: AppSpacing.space8),
                      Text(
                        'This helps personalise your experience. Stored locally on your device.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.space32),
                      const _ProfileForm(),
                    ],
                  ),
                ),
              ),
              const _ProfileActions(),
            ],
          ),
        ),
      ),
    );
  }
}

/// The form section containing name, university, GPA scale, and info banner.
class _ProfileForm extends StatelessWidget {
  /// Creates a [_ProfileForm].
  const _ProfileForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _NameField(),
        const SizedBox(height: AppSpacing.space16),
        const _UniversityField(),
        const SizedBox(height: AppSpacing.space24),
        const _GpaScaleSelector(),
        const SizedBox(height: AppSpacing.space16),
        const _InfoBanner(),
      ],
    );
  }
}

/// The name input field.
class _NameField extends StatelessWidget {
  /// Creates a [_NameField].
  const _NameField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('profile_name'),
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      style: AppTypography.bodyMedium,
      decoration: const InputDecoration(
        labelText: 'YOUR NAME',
      ),
      onChanged: (String value) {
        context.read<OnboardingBloc>().add(NameChanged(value));
      },
    );
  }
}

/// The university/school input field.
class _UniversityField extends StatelessWidget {
  /// Creates a [_UniversityField].
  const _UniversityField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('profile_university'),
      textInputAction: TextInputAction.done,
      textCapitalization: TextCapitalization.words,
      style: AppTypography.bodyMedium,
      decoration: const InputDecoration(
        labelText: 'UNIVERSITY / SCHOOL',
        hintText: 'e.g. University of Colombo',
      ),
      onChanged: (String value) {
        context.read<OnboardingBloc>().add(UniversityChanged(value));
      },
    );
  }
}

/// The segmented GPA scale selector (4.2 / 4.0).
class _GpaScaleSelector extends StatelessWidget {
  /// Creates a [_GpaScaleSelector].
  const _GpaScaleSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'GPA SCALE',
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.textPlaceholder,
            letterSpacing: 0.04 * 10,
          ),
        ),
        const SizedBox(height: AppSpacing.space4),
        Text(
          'Choose your institution\'s grading system',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        BlocBuilder<OnboardingBloc, OnboardingState>(
          buildWhen: (OnboardingState prev, OnboardingState curr) =>
              prev.gpaType != curr.gpaType,
          builder: (BuildContext context, OnboardingState state) {
            return _GpaScaleToggle(
              selectedGpaType: state.gpaType,
              onChanged: (int type) {
                context.read<OnboardingBloc>().add(GpaTypeChanged(type));
              },
            );
          },
        ),
      ],
    );
  }
}

/// The actual segmented toggle control for 4.2 vs 4.0 scale.
class _GpaScaleToggle extends StatelessWidget {
  /// The currently selected GPA type (`0` = 4.0, `1` = 4.2).
  final int selectedGpaType;

  /// Called when the user selects a different scale.
  final ValueChanged<int> onChanged;

  /// Creates a [_GpaScaleToggle].
  const _GpaScaleToggle({
    required this.selectedGpaType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _ScaleSegment(
            label: '4.2 Scale',
            sublabel: 'A+ = 4.2',
            isSelected: selectedGpaType == 1,
            onTap: () => onChanged(1),
          ),
          const SizedBox(width: 4),
          _ScaleSegment(
            label: '4.0 Scale',
            sublabel: 'A+ = 4.0',
            isSelected: selectedGpaType == 0,
            onTap: () => onChanged(0),
          ),
        ],
      ),
    );
  }
}

/// A single selectable segment within [_GpaScaleToggle].
class _ScaleSegment extends StatelessWidget {
  /// The primary label for this segment (e.g., "4.2 Scale").
  final String label;

  /// The subtitle shown below the label (e.g., "A+ = 4.2").
  final String sublabel;

  /// Whether this segment is currently selected.
  final bool isSelected;

  /// Called when this segment is tapped.
  final VoidCallback onTap;

  /// Creates a [_ScaleSegment].
  const _ScaleSegment({
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTypography.labelLarge.copyWith(
                  color:
                      isSelected ? AppColors.surface : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
              Text(
                sublabel,
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.surface
                      : AppColors.textPlaceholder,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// An informational banner reminding users they can change the GPA scale in Settings.
class _InfoBanner extends StatelessWidget {
  /// Creates an [_InfoBanner].
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.space12,
      ),
      decoration: BoxDecoration(
        color: AppColors.accentTint,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.info,
            size: 16,
            color: AppColors.accent,
          ),
          const SizedBox(width: AppSpacing.space8),
          Expanded(
            child: Text(
              'You can change this later in Settings.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The bottom action bar containing the Continue and Back buttons.
class _ProfileActions extends StatelessWidget {
  /// Creates a [_ProfileActions].
  const _ProfileActions();

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
          BlocBuilder<OnboardingBloc, OnboardingState>(
            buildWhen: (OnboardingState prev, OnboardingState curr) =>
                prev.isProfileValid != curr.isProfileValid ||
                prev.status != curr.status,
            builder: (BuildContext context, OnboardingState state) {
              final bool isLoading = state.status == OnboardingStatus.loading;
              return SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: state.isProfileValid && !isLoading
                      ? () => context
                          .read<OnboardingBloc>()
                          .add(const ProfileSubmitted())
                      : null,
                  icon: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.surface,
                          ),
                        )
                      : const Icon(LucideIcons.chevronRight),
                  label: const Text('Continue'),
                  iconAlignment: IconAlignment.end,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.space8),
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(LucideIcons.chevronLeft, color: AppColors.textSecondary),
            label: Text(
              'Back',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
