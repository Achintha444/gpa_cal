import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gpa_cal/features/add_semester/presentation/pages/add_semester_page.dart';
import 'package:gpa_cal/features/analytics/presentation/pages/analytics_page.dart';
import 'package:gpa_cal/features/dashboard/presentation/pages/home_page.dart';
import 'package:gpa_cal/features/edit_semester/presentation/pages/edit_semester_page.dart';
import 'package:gpa_cal/features/onboarding/presentation/pages/first_semester_page.dart';
import 'package:gpa_cal/features/onboarding/presentation/pages/profile_setup_page.dart';
import 'package:gpa_cal/features/onboarding/presentation/pages/welcome_page.dart';
import 'package:gpa_cal/features/semester_detail/presentation/pages/semester_detail_page.dart';
import 'package:gpa_cal/features/settings/presentation/pages/settings_page.dart';
import 'package:gpa_cal/features/splash/presentation/pages/splash_page.dart';
import 'package:gpa_cal/features/what_if/presentation/pages/what_if_page.dart';
import 'package:gpa_cal/shared/widgets.dart';

/// Defines all named route constants for the GPA Cal app.
///
/// Use these constants with `context.goNamed()` and `context.pushNamed()`
/// rather than raw string literals to prevent typo-driven navigation bugs.
abstract final class AppRoutes {
  /// The initial splash/launch route.
  static const String splash = 'splash';

  /// The welcome screen shown on first launch.
  static const String welcome = 'welcome';

  /// The profile setup screen for entering name, university, and GPA type.
  static const String profileSetup = 'profileSetup';

  /// The first-semester entry screen shown immediately after profile setup.
  static const String firstSemester = 'firstSemester';

  /// The main home dashboard route (bottom-nav shell tab: home).
  static const String home = 'home';

  /// The add-semester route for creating a new semester.
  ///
  /// Expects `extra` as a `Map<String, dynamic>` with:
  /// - `'name'` (`String`): the semester name entered in [SemesterNameSheet].
  /// - `'gpaType'` (`int`, optional, default `0`): the user's GPA scale type.
  static const String addSemester = 'addSemester';

  /// The edit-semester route. Requires `:hash` path parameter.
  ///
  /// Accepts `extra` as a `Map<String, dynamic>` with:
  /// - `'gpaType'` (`int`, optional, default `0`): the user's GPA scale type.
  static const String editSemester = 'editSemester';

  /// The semester-detail route. Requires `:hash` path parameter.
  static const String semesterDetail = 'semesterDetail';

  /// The analytics tab route (bottom-nav shell tab: analytics).
  static const String analytics = 'analytics';

  /// The what-if calculator route.
  static const String whatIf = 'whatIf';

  /// The settings route (bottom-nav shell tab: settings).
  static const String settings = 'settings';
}

/// The application's GoRouter configuration.
///
/// Uses [StatefulShellRoute.indexedStack] for the bottom-navigation shell
/// (Home, Analytics, Settings). Starts at the splash screen.
///
/// Navigation notes:
/// - Use `context.goNamed(AppRoutes.home)` for replacement navigation.
/// - Use `context.pushNamed(AppRoutes.addSemester)` for stack navigation.
/// - Pass data via `pathParameters` or `extra` — not constructor injection.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[
    // -------------------------------------------------------------------------
    // Splash
    // -------------------------------------------------------------------------
    GoRoute(
      path: '/splash',
      name: AppRoutes.splash,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
    ),

    // -------------------------------------------------------------------------
    // Onboarding
    // -------------------------------------------------------------------------
    GoRoute(
      path: '/welcome',
      name: AppRoutes.welcome,
      builder: (BuildContext context, GoRouterState state) {
        return const WelcomePage();
      },
    ),
    GoRoute(
      path: '/profile-setup',
      name: AppRoutes.profileSetup,
      builder: (BuildContext context, GoRouterState state) {
        return const ProfileSetupPage();
      },
    ),
    GoRoute(
      path: '/first-semester',
      name: AppRoutes.firstSemester,
      builder: (BuildContext context, GoRouterState state) {
        return const FirstSemesterPage();
      },
    ),

    // -------------------------------------------------------------------------
    // Main shell with bottom navigation (Home / Analytics / Settings)
    // -------------------------------------------------------------------------
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return BottomNavShell(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Home branch
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              name: AppRoutes.home,
              builder: (BuildContext context, GoRouterState state) {
                return const HomePage();
              },
            ),
          ],
        ),
        // Analytics branch
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/analytics',
              name: AppRoutes.analytics,
              builder: (BuildContext context, GoRouterState state) {
                return const AnalyticsPage();
              },
            ),
          ],
        ),
        // Settings branch
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              name: AppRoutes.settings,
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsPage();
              },
            ),
          ],
        ),
      ],
    ),

    // -------------------------------------------------------------------------
    // Modal / push routes (outside the shell)
    // -------------------------------------------------------------------------

    /// Add Semester — expects `extra` as `Map<String, dynamic>`:
    ///   `{'name': String, 'gpaType': int (optional)}`
    GoRoute(
      path: '/add-semester',
      name: AppRoutes.addSemester,
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic> extra =
            (state.extra as Map<String, dynamic>?) ?? {};
        final String semesterName = extra['name'] as String? ?? '';
        final int gpaType = extra['gpaType'] as int? ?? 0;
        return AddSemesterPage(semesterName: semesterName, gpaType: gpaType);
      },
    ),

    /// Edit Semester — requires `:hash` path parameter.
    /// Accepts `extra` as `Map<String, dynamic>`:
    ///   `{'gpaType': int (optional)}`
    GoRoute(
      path: '/edit-semester/:hash',
      name: AppRoutes.editSemester,
      builder: (BuildContext context, GoRouterState state) {
        final int hash = int.tryParse(state.pathParameters['hash'] ?? '') ?? 0;
        final Map<String, dynamic> extra =
            (state.extra as Map<String, dynamic>?) ?? {};
        final int gpaType = extra['gpaType'] as int? ?? 0;
        return EditSemesterPage(semesterHash: hash, gpaType: gpaType);
      },
    ),

    /// Semester Detail — requires `:hash` path parameter.
    /// Accepts `extra` as `Map<String, dynamic>`:
    ///   `{'gpaType': int (optional)}`
    GoRoute(
      path: '/semester-detail/:hash',
      name: AppRoutes.semesterDetail,
      builder: (BuildContext context, GoRouterState state) {
        final int hash = int.tryParse(state.pathParameters['hash'] ?? '') ?? 0;
        final Map<String, dynamic> extra =
            (state.extra as Map<String, dynamic>?) ?? {};
        final int gpaType = extra['gpaType'] as int? ?? 0;
        return SemesterDetailPage(semesterHash: hash, gpaType: gpaType);
      },
    ),

    GoRoute(
      path: '/what-if',
      name: AppRoutes.whatIf,
      builder: (BuildContext context, GoRouterState state) {
        return const WhatIfPage();
      },
    ),
  ],
);

