---
name: core-infrastructure
description: Entity fields, Hive typeIds, box names, adapter patterns, and GPA calculator API established in the foundation layer build
metadata:
  type: project
---

Core infrastructure was built in the foundation layer. Key facts to recall in future sessions:

**Why:** This is the authoritative reference so future feature builds don't re-derive these facts from scratch.

**How to apply:** Read this before implementing any feature to pick up the right imports and patterns.

## Entities (`lib/core/entities/`)

| Entity | Key fields |
|--------|-----------|
| `Subject` | `courseName`, `grade`, `credit` |
| `Semester` | `hash` (int, ms timestamp), `name`, `sgpa`, `totalResult`, `totalCredit`, `subjectList` |
| `UserDetails` | `name`, `university`, `gpaType` (0=4.0, 1=4.2) |
| `UserResult` | `cgpa`, `cumulativeResult`, `cumulativeCredit`, `semesters` |

Note: Old code used `course`/`result` field names. New entities use `courseName`/`grade`. Old code had typos `carrerResult`/`carrerCredit` — fixed to `cumulativeResult`/`cumulativeCredit`.

## Hive Models

| Model | typeId | Box constant |
|-------|--------|-------------|
| `SemesterModel` | 0 | `CacheKeys.hiveSemesterBox` (not used directly — result box holds the list) |
| `SubjectModel` | 1 | (nested inside SemesterModel) |
| `UserDetailsModel` | 2 | `CacheKeys.hiveUserDetailsBox` |
| `UserResultModel` | 3 | `CacheKeys.hiveUserResultBox` |

Adapters are manually written `.g.dart` files (build_runner not run yet). Pattern: read `numOfFields` byte, then iterate field-index/value pairs.

HiveObject subclasses MUST declare an explicit no-arg constructor `ClassName();` — otherwise `new_with_undefined_constructor_default` analysis error fires.

## Cache Keys (`lib/core/constants/cache_keys.dart`)

- Record key in user details box: `CacheKeys.userDetails = 'user_details'`
- Record key in user result box: `CacheKeys.userResults = 'user_results'`
- Box names: `hiveUserDetailsBox`, `hiveUserResultBox`, `hiveSemesterBox`

## GPA Calculator (`lib/core/utils/gpa_calculator.dart`)

```dart
GpaCalculator.calculateSgpa(subjects: subjects, gpaType: gpaType)  // → double
GpaCalculator.calculateCgpa(totalResult: r, totalCredit: c)        // → double
GpaCalculator.gradePointFor(grade, gpaType)                         // → double
```

All return `0.0` on division-by-zero. Results use `toStringAsPrecision(3)`.

## Repository Storage Pattern

`SemesterRepositoryImpl` stores a **single `UserResultModel`** record (key: `userResults`) in `hiveUserResultBox`. There is no separate semester box used — semesters are nested inside the `UserResultModel`.

`editSemester` and `deleteSemester` recalculate cumulative totals by iterating the updated semester list via `fold`.

## Router

App routes are in `lib/app/router.dart`. Named routes use `AppRoutes.<constant>`. Router instance is `appRouter` (exported from `router.dart`). Shell uses `StatefulShellRoute.indexedStack` for 3 tabs: Home / Analytics / Settings.

All page builders currently use `_PlaceholderPage` — replace with real pages as features are built.

## Old code location

Legacy code lives in `lib/ui/`, `lib/db/`, `lib/util/` — do NOT delete. It will be cleaned up later. New code lives exclusively in `lib/features/`, `lib/core/`, `lib/app/`.
