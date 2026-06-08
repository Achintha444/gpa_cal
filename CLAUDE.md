# GPA Cal — Claude Code Project Guide

> A mobile GPA calculator for students. Track semesters, calculate SGPA & CGPA across 4.0 and 4.2 grading scales.

## Project Overview

GPA Cal is a Flutter mobile app that helps university and school students calculate and track their Grade Point Average. It supports two grading scales (4.0 and 4.2), manages multiple semesters with per-course grades and credits, and computes both Semester GPA (SGPA) and Cumulative GPA (CGPA). The app is offline-first with all data stored locally.

## Collaboration Principles

- **Disagree when it matters.** If a proposed approach introduces security vulnerabilities, architectural instability, long-term maintenance burden, data integrity risks, or is factually incorrect — push back clearly with reasoning. Explain the risk, suggest alternatives, and let the user make an informed choice.
- **Read docs before advising.** For any technology topic — tools, services, frameworks, libraries — always fetch and read the official documentation first. Never rely solely on training data.
- **Think before coding.** State assumptions explicitly. Present multiple interpretations when ambiguity exists. Push back when a simpler approach exists. Stop when confused and ask for clarification.

## Development Principles

- **Consistency is key.** Follow established patterns in the codebase for architecture, state management, DI, navigation, and theming.
- **Documentation is essential.** All public and private classes and methods must have `///` doc comments explaining their purpose, parameters, and return values.
- **No TODOs in code.** All code must be fully implemented. If existing TODOs are found in files being modified, they should be addressed as part of the changes.
- **Use DI for services.** Never directly instantiate repositories in BLoCs. Use constructor injection to ensure testability.
- **Goal-Driven Execution.** For multi-step tasks, state a brief plan with verification steps before coding.

## Architecture

- **Clean Architecture** with feature-first folder structure
- **Dependency flow**: `Presentation → Domain ← Data`
- **State management**: BLoC / flutter_bloc (NOT Riverpod)
- **Database**: Hive (local, offline-first)
- **Routing**: GoRouter with named routes
- **Theme**: Editorial with Inter Tight + Inter fonts (Google Fonts)

```
lib/
├── app/              # Entry point, router, app widget
├── core/             # Shared entities, utilities, errors, extensions, constants
│   ├── entities/     # Shared domain entities (Subject, Semester, UserResult, UserDetails)
│   ├── constants/    # Cache keys, GPA conversion tables
│   ├── errors/       # Custom failure classes
│   ├── extensions/   # Dart/Flutter extensions
│   └── utils/        # GPA calculation, input formatters, logging
├── theme/            # Colors, typography, spacing tokens, decorations, ThemeData
├── shared/           # Cross-feature reusable widgets (app bar, glass effect, buttons, dialogs)
└── features/         # Feature modules (vertical slices)
    └── <feature>/
        ├── domain/        # Repository interfaces
        ├── data/          # Hive models, datasources, repository implementations
        └── presentation/  # BLoCs, pages, widgets
```

## Key Documents

| Document | Purpose |
| --- | --- |
| `docs/00-agent-development-rules.md` | Non-negotiable rules for all agents |
| `docs/01-architecture-principles.md` | Authoritative architecture spec |
| `docs/02-design-system.md` | Authoritative design token reference (colors, type, spacing, components) |
| `docs/03-ux-research-report.md` | UX research, competitive analysis, and design direction |
| `docs/04-screen-plan.md` | Screen-by-screen redesign plan — 11 screens, 3 priorities |
| `docs/tasks.md` | Full project tracker — 24 use cases, 17 designs, 52 dev tasks |

## GPA Domain Rules

- Two grading scales: **4.0** (gpaType=0) and **4.2** (gpaType=1) with distinct grade-to-point mappings
- GPA calculation is enforced in the **domain layer** (repositories/use cases), NOT in UI widgets
- SGPA = sum(grade_point * credit) / sum(credit) for a semester
- CGPA = sum(all_semester_total_result) / sum(all_semester_total_credit)
- Semesters are identified by a hash code for uniqueness

## Code Style

### Documentation

- Add `///` doc comments on **all classes and methods** (public and private)
- Only add inline comments when the WHY is non-obvious
- Don't reference tickets, issues, or callers in comments

### Dart Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables: `camelCase`
- BLoCs: `PascalCase` + `Bloc` suffix
- Events: `PascalCase` + `Event` suffix
- States: `PascalCase` + `State` suffix
- Always specify explicit types on local variables
- Use `package:` imports inside `lib/`

### State Management (BLoC)

- Use `Equatable` for all Events and States
- Use `copyWith()` on States (not `clone()`)
- Deep-copy mutable collections (Maps, Lists) in state transitions — never share references
- `BlocProvider` at the widget tree level, not as custom wrapper classes
- `BlocBuilder` for UI rebuilds, `BlocListener` for side effects (navigation, snackbars)
- No `setState` for state managed by BLoC

### Theme Tokens

- Colors: `AppColors` — never `Color(0xFF...)`
- Typography: `AppTypography` — never custom `TextStyle(...)`
- Spacing: `AppSpacing` — never raw numbers
- Headings: Inter Tight (via `google_fonts` package)
- Body: Inter (via `google_fonts` package)
- Accent: vibrant blue `#2563EB`, GPA numbers: warm orange `#F97316`
- Cards: solid borders `#E2E8F0`, no heavy shadows
- Inputs: filled style (`#F1F5F9` bg, no border at rest)
- 8pt spacing grid

## UI States

All screens must handle: **loading**, **error** (with retry), **empty**, **success**

## Tech Stack

| Concern | Package |
| --- | --- |
| State | `flutter_bloc`, `bloc` |
| DB | `hive`, `hive_flutter` |
| Router | `go_router` |
| Fonts | `google_fonts` (Inter Tight + Inter) |
| SVG | `flutter_svg` |
| Icons | `lucide_icons`, `cupertino_icons` |
| Code Gen | `build_runner`, `hive_generator` |
| Launcher | `flutter_launcher_icons` |

## Agents

- **flutter-developer** (blue) — Flutter developer agent. Implements features following Clean Architecture with BLoC + Hive.
- **ui-ux-design** (yellow) — Paper MCP designer. Creates screen mockups, reviews design system compliance, writes developer handoff specs.

## Git Rules

- Never commit or push — the user owns commit authorship
- Never run destructive git operations
- Report changes via summary only
