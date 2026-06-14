---
name: project-shared-widgets
description: Shared widget inventory, patterns, and decisions made during initial widget build
metadata:
  type: project
---

8 shared widgets implemented in `lib/shared/widgets/`, all exported from `lib/shared/widgets.dart`.

**Why:** These widgets are cross-feature primitives — used by home, add_semester, edit_semester, onboarding, and potentially analytics.

**How to apply:** Always import via `package:gpa_cal/shared/widgets.dart` barrel.

## Widget inventory

| Widget | File | Notes |
|---|---|---|
| `GradeChipSelector` | `grade_chip_selector.dart` | A/B/C/D-F color bands; uses pre-computed alpha tint constants |
| `CreditStepper` | `credit_stepper.dart` | Min/max/step, formats decimals as int when whole |
| `CourseEntryCard` | `course_entry_card.dart` | Stateful for TextEditingController lifecycle; syncs via didUpdateWidget |
| `SemesterCard` | `semester_card.dart` | Inter Tight 22px bold for SGPA, gpa color |
| `EmptyStateView` | `empty_state_view.dart` | Icon circle uses `Color(0x732563EB)` for 45% accent |
| `BottomNavShell` | `bottom_nav_shell.dart` | Wraps StatefulNavigationShell; uses `LucideIcons.home` (not `.house`) |
| `SgpaBar` | `sgpa_bar.dart` | 48px height, surfaceMuted bg, screenPadding insets |
| `StepIndicator` | `step_indicator.dart` | 1-based currentStep; active = accent, inactive = border |

## Key decisions

- `LucideIcons.house` does NOT exist in v0.257.0 — use `LucideIcons.home`
- `CourseEntryCard` is `StatefulWidget` because it owns `TextEditingController`; `didUpdateWidget` syncs text if subject changes externally
- `CreditStepper` uses `double.parse(value.toStringAsFixed(1))` to avoid floating-point drift when stepping
- `BorderRadius.subtract()` used to produce 10px radius buttons inside 12px-radius container (4px padding)
- Pre-existing `lib/ui/` code has 44 `withOpacity()` warnings — unrelated to new shared widgets
