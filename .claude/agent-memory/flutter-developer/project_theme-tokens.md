---
name: project_theme-tokens
description: V4 Editorial theme token files and their locations in the GPA Cal codebase
metadata:
  type: project
---

The V4 Editorial theme layer is live at `lib/theme/`. The old `project_theme.dart` is kept untouched for backward compatibility during migration.

**Token files:**
- `lib/theme/app_colors.dart` — `AppColors` abstract final class, all `const Color`
- `lib/theme/app_typography.dart` — `AppTypography` abstract final class, static `TextStyle` getters via `GoogleFonts.interTight` / `GoogleFonts.inter`
- `lib/theme/app_spacing.dart` — `AppSpacing` abstract final class, spacing doubles + `BorderRadius` constants
- `lib/theme/app_decorations.dart` — `AppDecorations` abstract final class, `BoxDecoration` + `BoxShadow` constants
- `lib/theme/app_theme.dart` — `appTheme()` top-level function returning `ThemeData`

**Shared widgets barrel:** `lib/shared/widgets.dart` (no widgets yet, just the barrel structure)

**Fonts:** Inter Tight (headings) + Inter (body) via `google_fonts`. Montserrat removed from `pubspec.yaml`.

**Key dependency versions resolved:**
- `lucide_icons: ^0.257.0` (NOT ^0.0.3 — that version doesn't exist on pub.dev)
- `google_fonts: ^6.2.1`
- `go_router: ^14.0.0`
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0`
- `equatable: ^2.0.5`
- `build_runner: ^2.4.9` + `hive_generator: ^2.0.1` (dev)

**Why:** Theme layer was rebuilt from Montserrat/SCREAMING_CASE old system to Editorial design system with modern Dart syntax.
