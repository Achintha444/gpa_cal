---
name: onboarding-flow-architecture
description: Architecture decisions for the splash + onboarding multi-screen flow (BLoC scope, navigation)
metadata:
  type: project
---

## OnboardingBloc is provided at the app root level (not at the page level)

The onboarding flow spans two separate GoRouter routes (`/profile-setup` → `/first-semester`).
Navigation between them uses `context.goNamed()`, which replaces the route stack and
destroys any `BlocProvider` that lived inside the previous page widget.

**Why:** If `OnboardingBloc` were provided inside `ProfileSetupPage`, navigating away
with `goNamed` would destroy the bloc before `FirstSemesterPage` could read `gpaType`
from its state — causing a "bloc not found" error or losing the selected GPA type.

**How to apply:** Provide multi-screen flow BLoCs in `app.dart` via `MultiBlocProvider`
(alongside repository providers), using a `Builder` to read the repos from context first.

## SplashBloc is provided at the page level (not app root)

`SplashBloc` is single-screen — it does its work and navigates away immediately.
It's safe to provide it inside `SplashPage` with `BlocProvider`.

## Shared widget discovery: always check lib/shared/widgets/ first

The `lib/shared/widgets/` directory already contained production-ready implementations
of `CourseEntryCard`, `StepIndicator`, `SgpaBar`, `CreditStepper`, `GradeChipSelector`,
and `BottomNavShell` that were not visible from the barrel export at the start of the task.

**How to apply:** Before implementing any widget, grep the shared directory and read
the barrel file `lib/shared/widgets.dart` to discover what exists.

## CourseEntryCard shared widget API

```dart
CourseEntryCard(
  subject: subject,
  index: index,          // zero-based position in list
  canDelete: bool,       // hides delete button when false
  gpaType: int,          // takes gpaType directly, not grades list
  onChanged: ValueChanged<Subject>,
  onDelete: VoidCallback, // required (not nullable)
)
```

## BottomNavShell is in lib/shared/widgets/

The `_BottomNavShell` placeholder in `router.dart` should be replaced with
`BottomNavShell` from `package:gpa_cal/shared/widgets.dart`.
