import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/app/router.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_bloc.dart';
import 'package:gpa_cal/features/dashboard/presentation/bloc/home_event.dart';
import 'package:gpa_cal/features/onboarding/data/repositories/user_details_repository_impl.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:gpa_cal/features/semester/data/repositories/semester_repository_impl.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/theme/app_theme.dart';

/// The root application widget for GPA Cal.
///
/// Sets up dependency injection via [MultiRepositoryProvider] and a
/// [MultiBlocProvider] for long-lived BLoCs. Configures [MaterialApp.router]
/// with the V4 Editorial theme and the GoRouter instance.
///
/// Repository instances are created once here and provided to the entire
/// widget tree.
///
/// Long-lived BLoCs at the app level:
/// - [OnboardingBloc]: persists state across the multi-screen onboarding flow.
/// - [HomeBloc]: persists at app level so it can be refreshed after any
///   semester mutation (add, edit, delete) without being destroyed by
///   [StatefulShellRoute.indexedStack].
class GpaCalApp extends StatelessWidget {
  /// Creates the [GpaCalApp] root widget.
  const GpaCalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: <RepositoryProvider<dynamic>>[
        RepositoryProvider<SemesterRepository>(
          create: (_) => SemesterRepositoryImpl(),
        ),
        RepositoryProvider<UserDetailsRepository>(
          create: (_) => UserDetailsRepositoryImpl(),
        ),
      ],
      child: Builder(
        builder: (BuildContext ctx) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<OnboardingBloc>(
                create: (_) => OnboardingBloc(
                  userDetailsRepository: ctx.read<UserDetailsRepository>(),
                  semesterRepository: ctx.read<SemesterRepository>(),
                ),
              ),
              BlocProvider<HomeBloc>(
                create: (_) => HomeBloc(
                  semesterRepository: ctx.read<SemesterRepository>(),
                  userDetailsRepository: ctx.read<UserDetailsRepository>(),
                )..add(const HomeDataRequested()),
              ),
            ],
            child: MaterialApp.router(
              title: 'GPA Cal',
              debugShowCheckedModeBanner: false,
              theme: appTheme(),
              routerConfig: appRouter,
            ),
          );
        },
      ),
    );
  }
}
