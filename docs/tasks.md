# GPA Cal — Task Tracker

> Complete project tracker covering use cases, design, and development.

## Status Legend

- `[ ]` — Not started
- `[~]` — In progress
- `[x]` — Completed

---

## Part 1: Use Cases

### Core Use Cases (V1 — MVP)

| ID | Use Case | Description |
|----|----------|-------------|
| UC-01 | First Launch | New user opens app → splash → onboarding collects name, university, GPA type |
| UC-02 | Return Launch | Returning user opens app → splash → dashboard with existing data |
| UC-03 | Add Semester | User taps FAB → names semester via bottom sheet → enters courses with grades + credits → confirms → SGPA calculated, CGPA updated |
| UC-04 | View Dashboard | User sees CGPA hero card, trend indicator, goal progress, and all semester cards |
| UC-05 | View Semester Detail | User taps semester card → sees read-only course list, SGPA, credit summary |
| UC-06 | Edit Semester | User enters edit mode → modifies course names, grades, credits → saves → SGPA/CGPA recalculated |
| UC-07 | Rename Semester | User taps edit name → bottom sheet → new name saved |
| UC-08 | Delete Semester | User triggers delete → confirmation dialog → semester removed → CGPA recalculated |
| UC-09 | Add Course to Semester | User taps "+ Add Course" → new course card appears with default grade + credit |
| UC-10 | Remove Course from Semester | User taps delete on course → course removed (min 1 course enforced) → SGPA recalculated |
| UC-11 | Select Grade | User taps grade chip (replaces dropdown) → single-tap selection → SGPA recalculates live |
| UC-12 | Adjust Credits | User taps +/- on credit stepper → value changes → SGPA recalculates live |
| UC-13 | View Empty State | No semesters → illustrated empty state with "Add Your First Semester" CTA |

### Enhancement Use Cases (V2)

| ID | Use Case | Description |
|----|----------|-------------|
| UC-14 | View GPA Trends | User switches to Analytics tab → sees CGPA trend line chart across semesters |
| UC-15 | Compare Semesters | User sees best/worst semester cards, average SGPA, total credits summary |
| UC-16 | What-If Calculator | User sets target CGPA → system calculates required average grade for next semester |
| UC-17 | Set GPA Goal | User sets target CGPA (e.g., 3.50) → dashboard hero card shows progress bar toward goal |
| UC-18 | Course Name Autocomplete | User starts typing course name → suggestions from previously entered courses appear |
| UC-19 | Semester Template | User creates new semester → option to copy course structure from a previous semester |

### Polish Use Cases (V3)

| ID | Use Case | Description |
|----|----------|-------------|
| UC-20 | Change GPA Scale | User changes between 4.0 and 4.2 in Settings → all calculations update |
| UC-21 | Toggle Dark Mode | User selects Light/Dark/System theme in Settings → theme applies immediately |
| UC-22 | Export as PDF | User taps export → PDF transcript generated with all semester data → share sheet |
| UC-23 | Edit Profile | User edits name/university in Settings → saved immediately |
| UC-24 | Clear All Data | User taps clear data → double confirmation → all data removed → redirected to onboarding |

---

## Part 2: Design Tasks

### Design System (Completed)

| ID | Task | Status | Paper Artboard |
|----|------|--------|----------------|
| D-01 | Color Palette (light + dark + semantic) | `[x]` | `1-0` |
| D-02 | Typography Scale (9 levels) | `[x]` | `2F-0` |
| D-03 | Spacing & Grid (8 tokens + 5 radius) | `[x]` | `3U-0` |
| D-04 | Component Library (11 components) | `[x]` | `5T-0` |
| D-05 | Design System Documentation | `[x]` | `docs/02-design-system.md` |

### Screen Designs

| ID | Screen | Use Cases | Status | Paper Artboard |
|----|--------|-----------|--------|----------------|
| D-06 | Splash Screen | UC-01, UC-02 | `[x]` | `146-0` |
| D-07 | Onboarding Step 1: Welcome | UC-01 | `[x]` | `147-0` |
| D-08 | Onboarding Step 2: Profile | UC-01 | `[x]` | `148-0` |
| D-09 | Onboarding Step 3: First Semester | UC-01, UC-09, UC-11, UC-12 | `[x]` | `149-0` |
| D-10 | Dashboard (with data) | UC-04, UC-17 | `[x]` | `D-10 v2` |
| D-11 | Dashboard (empty state) | UC-13 | `[x]` | `D-11 v2` |
| D-12 | Dashboard (loading state) | UC-04 | `[x]` | `D-12 v2` |
| D-13 | Add Semester — Name Sheet | UC-03 | `[x]` | `D-13 v2` |
| D-14 | Add Semester — Course Entry | UC-03, UC-09, UC-10, UC-11, UC-12 | `[x]` | `D-14 v2` |
| D-15 | Semester Detail (read-only) | UC-05 | `[x]` | `16F-0` |
| D-16 | Edit Semester | UC-06, UC-07, UC-09, UC-10, UC-11, UC-12 | `[x]` | `16G-0` |
| D-17 | Delete Confirmation (Bottom Sheet) | UC-08 | `[x]` | `16H-0` |
| D-18 | Analytics Tab | UC-14, UC-15 | `[x]` | `172-0` |
| D-19 | What-If Calculator | UC-16 | `[x]` | `173-0` |
| D-20 | Analytics (empty / insufficient data) | UC-14 | `[x]` | `174-0` |
| D-21 | Settings | UC-20, UC-21, UC-23 | `[x]` | `179-0` |
| D-22 | Export / Share | UC-22 | `[x]` | `17A-0` |

---

## Part 3: Development Tasks — Architecture Refactor

### Phase 1: Quick Wins (no dependencies)

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-01 | Move SystemChrome.setPreferredOrientations to main() | All | `[ ]` |
| T-02 | Remove all `new` keyword usage (~15 instances) | All | `[ ]` |
| T-03 | Remove all debug `print()` statements (~40) | All | `[ ]` |
| T-04 | Remove unused import `flutter/rendering.dart` | — | `[ ]` |
| T-05 | Pin `bloc: any` to `bloc: ^8.1.0` | — | `[ ]` |
| T-06 | Tighten SDK constraint in pubspec.yaml | — | `[ ]` |
| T-07 | Remove unused named route `/splashFormPage` | — | `[ ]` |

### Phase 2: Core Architecture (entities + state)

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-08 | Adopt Equatable + copyWith for all States (replace clone) | All | `[ ]` |
| T-09 | Type-safe semester list (List\<Semester\> not List\<dynamic\>) | UC-03–UC-08 | `[ ]` |
| T-10 | Fix typos (carrer→cumulative, Stroage→Storage) + data migration | All | `[ ]` |
| T-11 | Fix Semester equality (Equatable, comes with T-08) | UC-06, UC-08 | `[ ]` |
| T-12 | Remove BuildContext from all BLoC constructors | All | `[ ]` |

### Phase 3: Data Layer Migration

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-13 | Set up Hive — models, adapters, init function | All | `[ ]` |
| T-14 | Implement SemesterRepository (interface + impl) | UC-03–UC-08 | `[ ]` |
| T-15 | Implement UserDetailsRepository (interface + impl) | UC-01, UC-02, UC-23 | `[ ]` |
| T-16 | One-time migration from SharedPreferences → Hive | UC-02 | `[ ]` |
| T-17 | Remove all SharedPreferences code and old repos | — | `[ ]` |

### Phase 4: Reduce Duplication

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-18 | Unify SubjectCard / EditSemesterSubjectCard / EditSmesterNewSubjectCard → single widget | UC-09–UC-12 | `[ ]` |
| T-19 | Unify AddSemesterBloc / EditSemesterBloc shared logic | UC-03, UC-06 | `[ ]` |
| T-20 | Fix `// ignore: must_be_immutable` — remove custom Provider wrappers | All | `[ ]` |
| T-21 | Fix widget list SizedBox(0,0) hack → state-driven list | UC-09, UC-10 | `[ ]` |

### Phase 5: Navigation & DI

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-22 | Add `equatable` and `go_router` dependencies | All | `[ ]` |
| T-23 | Implement GoRouter with named routes | All | `[ ]` |
| T-24 | Set up RepositoryProvider / MultiRepositoryProvider DI | All | `[ ]` |
| T-25 | Inject repositories via BLoC constructors | All | `[ ]` |

### Phase 6: Theme Tokens

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-26 | Create AppColors, AppTypography, AppSpacing, AppDecorations | All | `[ ]` |
| T-27 | Create AppTheme (light + dark ThemeData) | UC-21 | `[ ]` |
| T-28 | Replace all hardcoded Color(0xFF...) with AppColors | All | `[ ]` |
| T-29 | Replace all custom TextStyle() with AppTypography | All | `[ ]` |
| T-30 | Replace deprecated Color.withOpacity() (~30 instances) | All | `[ ]` |
| T-31 | Fix hardcoded CGPA "4.00/4.20" in AddSemesterAppBar | UC-03 | `[ ]` |

---

## Part 4: Development Tasks — Screen Implementation

### Phase 7: Foundation Screens

| ID | Task | Use Cases | Design Dep | Status |
|----|------|-----------|------------|--------|
| T-32 | Implement Splash Screen + auto-detect logic | UC-01, UC-02 | D-06 | `[ ]` |
| T-33 | Implement Onboarding Flow (3 steps) | UC-01 | D-07, D-08, D-09 | `[ ]` |
| T-34 | Implement Dashboard with CGPA Hero Card | UC-04, UC-13, UC-17 | D-10, D-11, D-12 | `[ ]` |
| T-35 | Implement GradeChipSelector widget | UC-11 | D-14 | `[ ]` |
| T-36 | Implement CreditStepper widget | UC-12 | D-14 | `[ ]` |
| T-37 | Implement Add Semester page | UC-03, UC-09, UC-10 | D-13, D-14 | `[ ]` |
| T-38 | Implement Semester Detail page (read-only) | UC-05 | D-15 | `[ ]` |
| T-39 | Implement Edit Semester page | UC-06, UC-07, UC-08 | D-16, D-17 | `[ ]` |
| T-40 | Implement Bottom Navigation Bar | UC-04 | D-10 | `[ ]` |

### Phase 8: Enhancement Screens

| ID | Task | Use Cases | Design Dep | Status |
|----|------|-----------|------------|--------|
| T-41 | Implement Analytics Tab (trend chart + summary) | UC-14, UC-15 | D-18, D-20 | `[ ]` |
| T-42 | Implement What-If Calculator | UC-16 | D-19 | `[ ]` |
| T-43 | Implement GPA Goal setting + progress bar | UC-17 | D-10 | `[ ]` |
| T-44 | Implement course name autocomplete | UC-18 | — | `[ ]` |

### Phase 9: Polish Screens

| ID | Task | Use Cases | Design Dep | Status |
|----|------|-----------|------------|--------|
| T-45 | Implement Settings page | UC-20, UC-21, UC-23, UC-24 | D-21 | `[ ]` |
| T-46 | Implement PDF export + share | UC-22 | D-22 | `[ ]` |
| T-47 | Implement semester template / copy structure | UC-19 | — | `[ ]` |

### Phase 10: Testing

| ID | Task | Use Cases | Status |
|----|------|-----------|--------|
| T-48 | Unit tests: GpaCalculator (both scales, edge cases) | UC-03, UC-06 | `[ ]` |
| T-49 | Unit tests: BLoC state transitions (Home, AddSemester, EditSemester) | UC-03–UC-08 | `[ ]` |
| T-50 | Unit tests: Repository CRUD operations | UC-03–UC-08 | `[ ]` |
| T-51 | Widget tests: GradeChipSelector, CreditStepper, SemesterCard | UC-11, UC-12 | `[ ]` |
| T-52 | Integration tests: full add semester → view dashboard flow | UC-03, UC-04 | `[ ]` |

---

## Progress Summary

| Section | Total | Done | Remaining |
|---------|-------|------|-----------|
| Design System | 5 | 5 | 0 |
| Screen Designs | 17 | 17 | 0 |
| Phase 1: Quick Wins | 7 | 0 | 7 |
| Phase 2: Core Architecture | 5 | 0 | 5 |
| Phase 3: Data Layer | 5 | 0 | 5 |
| Phase 4: Duplication | 4 | 0 | 4 |
| Phase 5: Navigation & DI | 4 | 0 | 4 |
| Phase 6: Theme Tokens | 6 | 0 | 6 |
| Phase 7: Foundation Screens | 9 | 0 | 9 |
| Phase 8: Enhancement Screens | 4 | 0 | 4 |
| Phase 9: Polish Screens | 3 | 0 | 3 |
| Phase 10: Testing | 5 | 0 | 5 |
| **Total** | **74** | **22** | **52** |

---

## Execution Strategy

### Track 1: Design (UI/UX Design Agent)
```
D-06→D-07→D-08→D-09 (Splash + Onboarding)
  ↓
D-10→D-11→D-12→D-13→D-14 (Dashboard + Add Semester)
  ↓
D-15→D-16→D-17 (Detail + Edit + Dialog)
  ↓
D-18→D-19→D-20 (Analytics + What-If)
  ↓
D-21→D-22 (Settings + Export)
```

### Track 2: Development (Flutter Developer Agent)
```
Phase 1–2 (quick wins + architecture) — no design dependency
  ↓
Phase 3 (Hive migration) — no design dependency
  ↓
Phase 4–5 (dedup + navigation) — no design dependency
  ↓
Phase 6 (theme tokens) — depends on D-01→D-05 (done)
  ↓
Phase 7 (foundation screens) — depends on D-06→D-17
  ↓
Phase 8–9 (enhancement + polish) — depends on D-18→D-22
  ↓
Phase 10 (testing) — after architecture is stable
```

**Parallel execution:** Design and development Phases 1–6 can run in parallel. Screen implementation (Phase 7+) waits for corresponding designs.
