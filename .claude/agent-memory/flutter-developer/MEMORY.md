# Flutter Developer Agent — Memory

This file is loaded into the agent's system prompt. Keep it concise (under 200 lines).

## Feedback
- [No withOpacity()](feedback_no-withopacity.md) — Use pre-computed alpha hex `Color(0xAARRGGBB)` — `withOpacity()` is deprecated in current Flutter

## Project
- [V4 Theme token files](project_theme-tokens.md) — All theme token files, locations, key dependency versions, and migration notes
- [Core infrastructure](project_core-infrastructure.md) — Entity fields, Hive typeIds, box names, adapter patterns, and GPA calculator API
- [Shared widgets](project_shared-widgets.md) — 8 widgets in lib/shared/widgets/, icon gotchas (LucideIcons.home not .house), key patterns
- [Onboarding flow architecture](project_onboarding-flow.md) — BLoC scope for multi-screen flows, shared widget APIs (CourseEntryCard, StepIndicator)
- [App-level BLoC pattern](project_app-level-blocs.md) — HomeBloc and OnboardingBloc live at app root; BLoCs that must survive StatefulShellRoute navigation go in app.dart MultiBlocProvider
- [CRUD screen routing pattern](project_crud-routing.md) — gpaType propagation via route extras; semester hash as path param; HomeBloc refreshed after mutations before goNamed(home)
- [Tab screen BLoC pattern](project_tab-bloc-pattern.md) — Analytics and Settings BLoCs are route-scoped via BlocProvider inside the page widget; not at app root
