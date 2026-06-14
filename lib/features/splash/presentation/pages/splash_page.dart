import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:gpa_cal/features/splash/presentation/bloc/splash_event.dart';
import 'package:gpa_cal/features/splash/presentation/bloc/splash_state.dart';
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';
import 'package:gpa_cal/theme/app_typography.dart';

/// The launch splash screen for GPA Cal.
///
/// Provides [SplashBloc] via [BlocProvider] and immediately dispatches
/// [SplashCheckRequested] on build. A [BlocListener] waits for the bloc
/// result, then navigates after a 1.5-second delay:
/// - [SplashAuthenticated] → `/home`
/// - [SplashUnauthenticated] → `/welcome`
///
/// Route path: `/splash`
class SplashPage extends StatelessWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
      create: (BuildContext ctx) => SplashBloc(
        userDetailsRepository: ctx.read<UserDetailsRepository>(),
      )..add(const SplashCheckRequested()),
      child: const _SplashView(),
    );
  }
}

/// The internal view that renders the splash UI and handles navigation.
class _SplashView extends StatelessWidget {
  /// Creates a [_SplashView].
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (BuildContext ctx, SplashState state) async {
        if (state is SplashAuthenticated || state is SplashUnauthenticated) {
          // Delay navigation by 1.5s to let the splash render visibly.
          await Future<void>.delayed(const Duration(milliseconds: 1500));

          if (!ctx.mounted) return;

          if (state is SplashAuthenticated) {
            ctx.goNamed(AppRoutes.home);
          } else {
            ctx.goNamed(AppRoutes.welcome);
          }
        }
      },
      child: const Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: _SplashContent(),
        ),
      ),
    );
  }
}

/// The centered column content of the splash screen.
///
/// Displays the app logo and tagline.
class _SplashContent extends StatelessWidget {
  /// Creates a [_SplashContent].
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App logo
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              'graphics/launcher_icon-2.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: AppSpacing.space20),
          // Tagline
          Text(
            'Track your academic journey',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
