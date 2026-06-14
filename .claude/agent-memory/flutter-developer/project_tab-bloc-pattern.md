---
name: tab-bloc-pattern
description: Analytics and Settings BLoCs are scoped to their route via BlocProvider inside the page widget — not at the app root. Contrast with HomeBloc which lives at app root to survive tab switches.
metadata:
  type: project
---

Tab BLoCs (Analytics, Settings, WhatIf) are provided directly inside the page's `build` method using `BlocProvider` — they are created and disposed when the route is pushed/popped.

```dart
class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AnalyticsBloc>(
      create: (ctx) => AnalyticsBloc(
        semesterRepository: ctx.read<SemesterRepository>(),
        userDetailsRepository: ctx.read<UserDetailsRepository>(),
      )..add(const AnalyticsDataRequested()),
      child: const _AnalyticsView(),
    );
  }
}
```

**Why:** HomeBloc must survive `StatefulShellRoute.indexedStack` tab switches, so it lives at the app root. Tab BLoCs that always reload fresh data on mount don't need that — scoping them to the route keeps the app root MultiBlocProvider lean.

**How to apply:** Only elevate a BLoC to app root when it must preserve state across tab navigation (e.g., HomeBloc). All other feature BLoCs should be route-scoped.

**Also note:** `UserDetailsRepository.clearAll()` deletes both profile and semester data — SettingsBloc does NOT need a `SemesterRepository` injection. Check repository contracts before injecting unnecessary dependencies.
