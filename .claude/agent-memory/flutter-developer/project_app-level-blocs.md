---
name: app-level-blocs
description: Which BLoCs live at the app root level and why — HomeBloc and OnboardingBloc must persist across StatefulShellRoute navigation
metadata:
  type: project
---

## BLoCs at app.dart level (MultiBlocProvider)

`HomeBloc` and `OnboardingBloc` are both provided at the app root in `lib/app/app.dart` via `MultiBlocProvider`.

**Why:** GoRouter's `StatefulShellRoute.indexedStack` keeps branch state alive. If `HomeBloc` were page-scoped, it would not be destroyed when navigating within the home branch (e.g., after `context.goNamed(AppRoutes.home)` from add/edit-semester). Moving the BLoC to app level:
1. Guarantees it exists before any route renders.
2. Allows `AddSemesterPage` and `EditSemesterPage` to call `ctx.read<HomeBloc>().add(HomeDataRequested())` before navigating home, so the dashboard always reflects the latest data.

**How to apply:** Any BLoC that (a) must survive shell tab switching, or (b) is mutated from routes outside the shell, belongs in `app.dart`'s `MultiBlocProvider`. Feature-local BLoCs (like `AddSemesterBloc`, `EditSemesterBloc`, `SemesterDetailBloc`) remain page-scoped.

**Pattern used (app.dart):**
```dart
MultiBlocProvider(
  providers: [
    BlocProvider<OnboardingBloc>(create: ...),
    BlocProvider<HomeBloc>(
      create: (_) => HomeBloc(...)..add(const HomeDataRequested()),
    ),
  ],
  child: MaterialApp.router(...),
)
```
