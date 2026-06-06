# GPA Cal — Task Tracker

> Refactoring and modernization tasks identified from the initial codebase analysis.

## Status Legend

- `[ ]` — Not started
- `[~]` — In progress
- `[x]` — Completed

---

## Critical / High Priority

### T-01: Fix mutable state mutation in BLoC states
- **Status**: `[ ]`
- **Files**: `add_semester_state.dart`, `edit_semester_state.dart`, `home_state.dart`, `splash_screen_state.dart`, `splash_form_state.dart`
- **Problem**: State classes are annotated `@immutable` but `clone()` passes Map/List references. BLoC handlers mutate `subjects`, `totalResult`, `totalCredit`, `emptySubjects` in-place, breaking equality checks and causing subtle bugs.
- **Fix**: Replace `clone()` with `copyWith()` using `Equatable`. Deep-copy all mutable collections (`List.of()`, `Map.of()`). Use sealed event classes.

### T-02: Migrate data layer from SharedPreferences to Hive
- **Status**: `[ ]`
- **Files**: All repos (`home_repo.dart`, `splash_screen_repo.dart`, `splash_form_repo.dart`, `add_semester_repo.dart`, `edit_semester_repo.dart`), `cache_util.dart`
- **Problem**: All data stored as a single JSON blob in SharedPreferences. No type safety, no migration strategy, corrupt data = total data loss.
- **Fix**: Create Hive models with `@HiveType`/`@HiveField` annotations. Implement repository pattern with proper model ↔ entity mapping. Add one-time migration from SharedPreferences on first launch.

### T-03: Type-safe semester list in UserResultModel
- **Status**: `[ ]`
- **Files**: `user_result.dart`, all repos that interact with `semesters`
- **Problem**: `UserResultModel.semesters` is `List<dynamic>`, requiring runtime casts (`as Map<String, dynamic>`) everywhere. No compile-time safety.
- **Fix**: Change to `List<Semester>` with proper serialization. Update all repos and BLoCs to work with typed Semester objects.

### T-04: Fix hardcoded CGPA in AddSemesterAppBar
- **Status**: `[ ]`
- **Files**: `add_semester_appbar.dart:108`
- **Problem**: Displays static text `'4.00/4.20'` instead of actual CGPA data.
- **Fix**: Pass actual CGPA value and gpaType to the app bar widget and display dynamically.

### T-05: Move SystemChrome out of build()
- **Status**: `[ ]`
- **Files**: `root.dart:13`
- **Problem**: `SystemChrome.setPreferredOrientations()` called inside `build()` — this is a side-effect that runs on every rebuild.
- **Fix**: Move to `main()` before `runApp()`, awaiting the Future.

---

## Medium Priority

### T-06: Eliminate code duplication across subject cards
- **Status**: `[ ]`
- **Files**: `subject_card.dart`, `edit_semester_subject_card.dart`, `edit_semester_new_subject_card.dart`
- **Problem**: Three widgets with ~90% identical code (~310 lines each). Same `_inputDecortaiton`, `_inputErrorDecortaiton`, `_selectResultType`, `_selectResultMap` methods duplicated.
- **Fix**: Extract a single `SubjectCardWidget` with an optional `initialSubject` parameter. Share input decoration helpers via theme tokens or a shared widget.

### T-07: Eliminate BLoC duplication between Add and Edit semester
- **Status**: `[ ]`
- **Files**: `add_semester_bloc.dart`, `edit_semester_bloc.dart`, their events and states
- **Problem**: ~240 lines of near-identical logic in each BLoC (`_onAddSubjectsEvent` / `_onEditSubjectsEvent`, `_onDeleteSubjectEvent` / `_onDeleteEditSubjectEvent`, `_onTotalErrorEvent`, `_calculateTotalCredit`, `_returnSubjectList`, `_addErr`).
- **Fix**: Extract shared semester management logic into a base class or shared mixin. Keep only the difference (add vs edit persistence) in feature-specific BLoCs.

### T-08: Replace deprecated Color.withOpacity()
- **Status**: `[ ]`
- **Files**: ~30 occurrences across `root.dart`, `project_theme.dart`, `glass_effect.dart`, `custom_app_bar.dart`, `add_semester_appbar.dart`, `subject_card.dart`, `semester_card.dart`, `set_semester_name_dialog.dart`, `edit_name_bottom_sheet.dart`, `home_first_interface.dart`, and more
- **Problem**: `Color.withOpacity()` is deprecated in latest Flutter. Should use `Color.withValues(alpha: ...)`.
- **Fix**: Replace all `withOpacity(x)` calls with the modern API.

### T-09: Remove unnecessary `new` keyword
- **Status**: `[ ]`
- **Files**: ~15 instances across `project_theme.dart`, `home_view.dart`, `add_semester_view.dart`, `edit_semester_view.dart`, `add_semester_page.dart`, repos, BLoCs
- **Problem**: `new` keyword is unnecessary since Dart 2 and adds visual noise.
- **Fix**: Remove all `new` keyword usages.

### T-10: Implement dependency injection for repositories
- **Status**: `[ ]`
- **Files**: All BLoCs (`splash_screen_bloc.dart`, `splash_form_bloc.dart`, `home_bloc.dart`, `add_semester_bloc.dart`, `edit_semester_bloc.dart`)
- **Problem**: Repos instantiated as `static final` inside BLoCs. Not injectable, not testable, singleton anti-pattern.
- **Fix**: Pass repositories through BLoC constructors. Provide via `RepositoryProvider` / `MultiRepositoryProvider` at the widget tree level.

### T-11: Fix navigation pattern (push-and-rebuild)
- **Status**: `[ ]`
- **Files**: `home_view.dart`, `add_semester_view.dart`, `edit_semester_view.dart`, `splash_screen_view.dart`, `splash_form_view.dart`
- **Problem**: After add/edit/delete, the app does `Navigator.pushAndRemoveUntil` to rebuild `HomeProvider` from scratch, re-fetching all data. Wasteful and causes visual flicker.
- **Fix**: Adopt GoRouter with named routes. Use `context.goNamed('home')` for replacement, `context.pushNamed()` for stack navigation. Pass data via route parameters.

### T-12: Remove all debug print() statements
- **Status**: `[ ]`
- **Files**: ~40 occurrences across all repos and BLoCs
- **Problem**: Production code littered with `print()` calls for debugging. Leaks internal state to console.
- **Fix**: Remove all `print()` calls. Use the existing `Log` utility class where logging is genuinely needed, or remove entirely.

### T-13: Add test suite
- **Status**: `[ ]`
- **Files**: `test/` directory (currently empty)
- **Problem**: Zero tests. No confidence in correctness of GPA calculations, state transitions, or data persistence.
- **Fix**: Add unit tests for `GpaConversion` (both scales), BLoC state transitions, repository CRUD operations. Add widget tests for key components.

### T-14: Fix typos in error messages and model fields
- **Status**: `[ ]`
- **Files**: `user_result.dart` (`carrerResult`, `carrerCredit`), all BLoCs (`'Stroage Limit Exceed!'`)
- **Problem**: "Stroage" should be "Storage", "carrer" should be "career" (or better: "cumulative"). Typos in field names affect serialized data — requires migration.
- **Fix**: Rename fields to `cumulativeResult`/`cumulativeCredit`. Fix error message strings. Handle data migration for existing serialized data.

### T-15: Remove BuildContext from BLoC constructors
- **Status**: `[ ]`
- **Files**: All BLoCs (`SplashScreenBloc`, `SplashFormBloc`, `HomeBloc`, `AddSemesterBloc`, `EditSemesterBloc`)
- **Problem**: `BuildContext` accepted as constructor parameter but never used. Violates separation of concerns — BLoCs should not know about Flutter widgets.
- **Fix**: Remove `BuildContext` parameter from all BLoC constructors. Update all `BlocProvider` create callbacks.

### T-16: Fix `// ignore: must_be_immutable` in Views
- **Status**: `[ ]`
- **Files**: `home_view.dart`, `splash_screen_view.dart`, `splash_form_view.dart`, `add_semester_view.dart`, `edit_semester_view.dart`
- **Problem**: Mutable `GlobalKey<ScaffoldState>` fields in StatelessWidgets, warning suppressed with ignore comment.
- **Fix**: Either make the key `final` (it already is in most cases — remove the ignore), or convert to proper widget structure where keys are managed correctly.

---

## Low Priority / Polish

### T-17: Tighten SDK constraint
- **Status**: `[ ]`
- **Files**: `pubspec.yaml:21`
- **Problem**: `">=3.0.0 <4.0.0"` is too loose. Running on Dart 3.11.4 but allowing any 3.x.
- **Fix**: Update to `">=3.0.0 <4.0.0"` or `^3.0.0` — or tighten to `">=3.11.0 <4.0.0"` to match actual minimum.

### T-18: Remove unused import in project_theme.dart
- **Status**: `[ ]`
- **Files**: `project_theme.dart:2`
- **Problem**: `import 'package:flutter/rendering.dart'` is unused.
- **Fix**: Remove the import.

### T-19: Fix Semester equality (reference vs value)
- **Status**: `[ ]`
- **Files**: `edit_semester_bloc.dart:181`
- **Problem**: `if (semester == state.semester)` compares by reference since `Semester` doesn't implement `Equatable` or override `==`. Will always be `false` for different instances with same data.
- **Fix**: Implement `Equatable` on `Semester` (part of T-01 entity refactor), or compare by hash.

### T-20: Remove unused named route
- **Status**: `[ ]`
- **Files**: `root.dart:58`
- **Problem**: `/splashFormPage` defined in `routes` map but never used — all navigation uses `MaterialPageRoute` push.
- **Fix**: Remove the unused named route. Will be replaced entirely by GoRouter in T-11.

### T-21: Fix widget list management (SizedBox placeholders)
- **Status**: `[ ]`
- **Files**: `add_semester_page.dart`, `edit_semester_page.dart`
- **Problem**: Deleted subjects replaced with `SizedBox(height: 0, width: 0)` instead of being removed. List grows with phantom entries. Index-based tracking becomes fragile.
- **Fix**: Use a proper list model in BLoC state. Rebuild widget list from state on every emission instead of manually mutating a widget list.

### T-22: Pin `bloc: any` to a specific version
- **Status**: `[ ]`
- **Files**: `pubspec.yaml:37`
- **Problem**: `bloc: any` could pull incompatible major versions on `pub get`.
- **Fix**: Pin to a compatible version range (e.g., `bloc: ^8.1.0`) matching `flutter_bloc: ^8.1.3`.

---

## Execution Order (Recommended)

Grouped by dependency — later tasks depend on earlier ones being complete.

### Phase 1: Foundation (do first — everything else builds on this)
1. **T-05** — Move SystemChrome (quick win, no dependencies)
2. **T-09** — Remove `new` keyword (quick win, no dependencies)
3. **T-12** — Remove print() statements (quick win, no dependencies)
4. **T-18** — Remove unused import (quick win)
5. **T-22** — Pin `bloc: any` version (quick win)
6. **T-17** — Tighten SDK constraint (quick win)
7. **T-20** — Remove unused named route (quick win)

### Phase 2: Core Architecture (refactor entities and state)
8. **T-01** — Fix mutable state / adopt Equatable + copyWith (foundational)
9. **T-03** — Type-safe semester list (depends on T-01 entity refactor)
10. **T-14** — Fix typos in fields (bundle with T-03 since field names change)
11. **T-19** — Fix Semester equality (comes free with T-01)
12. **T-15** — Remove BuildContext from BLoCs (part of BLoC cleanup)

### Phase 3: Data Layer Migration
13. **T-02** — Migrate SharedPreferences → Hive (depends on T-01/T-03 for clean entities)

### Phase 4: Reduce Duplication
14. **T-06** — Unify subject card widgets (depends on T-01 state fixes)
15. **T-07** — Unify Add/Edit BLoC logic (depends on T-01, T-10)
16. **T-16** — Fix must_be_immutable ignores (depends on T-11 removing custom Providers)

### Phase 5: Navigation & DI
17. **T-10** — Dependency injection for repositories (depends on T-02 for Hive repos)
18. **T-11** — GoRouter navigation (depends on T-10 for proper DI at router level)

### Phase 6: Modernize APIs
19. **T-08** — Replace deprecated withOpacity() (can be done anytime, batched for efficiency)
20. **T-04** — Fix hardcoded CGPA in app bar (depends on T-11 for data flow)
21. **T-21** — Fix widget list management (depends on T-01 state-driven UI)

### Phase 7: Quality
22. **T-13** — Add tests (best done after architecture is stable from Phases 1-5)

---

## Progress Summary

| Priority | Total | Done | Remaining |
|----------|-------|------|-----------|
| Critical | 5 | 0 | 5 |
| Medium | 11 | 0 | 11 |
| Low | 6 | 0 | 6 |
| **Total** | **22** | **0** | **22** |
