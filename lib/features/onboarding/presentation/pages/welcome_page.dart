import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// The welcome screen — the first onboarding screen new users see.
///
/// Displays the app logo, headline, and a brief value proposition, with a
/// "Get Started" primary CTA that navigates to the profile setup screen.
///
/// Route path: `/welcome`
class WelcomePage extends StatelessWidget {
  /// Creates a [WelcomePage].
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Center content expands to push bottom actions down.
              const Expanded(child: _WelcomeHeroContent()),
              // Bottom action area
              _WelcomeActions(
                onGetStarted: () => context.goNamed(AppRoutes.profileSetup),
              ),
              const SizedBox(height: AppSpacing.space48),
            ],
          ),
        ),
      ),
    );
  }
}

/// The hero area — logo, title, and description — centred vertically.
class _WelcomeHeroContent extends StatelessWidget {
  /// Creates a [_WelcomeHeroContent].
  const _WelcomeHeroContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Illustration
        SvgPicture.asset(
          'graphics/person.svg',
        ),
        const SizedBox(height: AppSpacing.space48),
        // Headline
        Text(
          'Track your academic journey',
          style: AppTypography.displayLarge,
        ),
        const SizedBox(height: AppSpacing.space12),
        // Description
        Text(
          'Calculate your GPA across semesters with support for 4.0 and 4.2 grading scales. Free, offline, and private.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// The bottom action area containing the primary CTA and the disabled import option.
class _WelcomeActions extends StatelessWidget {
  /// Called when the "Get Started" button is tapped.
  final VoidCallback onGetStarted;

  /// Creates a [_WelcomeActions] widget.
  const _WelcomeActions({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Primary CTA
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: onGetStarted,
            child: const Text('Get Started'),
          ),
        ),
        const SizedBox(height: AppSpacing.space12),
        // Import option — disabled for V1
        Center(
          child: Text(
            'Already have data? Import',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPlaceholder,
            ),
          ),
        ),
      ],
    );
  }
}
