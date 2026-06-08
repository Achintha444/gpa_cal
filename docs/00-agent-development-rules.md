# Agent Development Rules

These rules are **NON-NEGOTIABLE**. They are designed to prevent architectural degradation by automated agents.

## 1. File Creation & Structure

1. **Feature-First Packaging**:
    - **DO**: Create new features as independent directories in `lib/features/<feature_name>/`.
    - **DO NOT**: Add feature-specific code to `lib/core/` or `lib/shared/`.
    - **DO NOT**: Create cross-feature dependencies.
2. **Shared Domain Entities**:
    - All domain entities (e.g., `Subject`, `Semester`, `UserResult`, `UserDetails`) live in `lib/core/entities/`.
    - **DO NOT** create `entities/` folders inside feature `domain/` directories.
    - Entities are shared across features — this is by design to avoid duplication.
3. **Theme & Tokens** (V4 Editorial — IMPLEMENTED):
    - All theme tokens live in `lib/theme/`.
    - Colors: `app_colors.dart` (`AppColors`) — surfaces, brand, semantic, derived tints
    - Typography: `app_typography.dart` (`AppTypography`) — Inter Tight headings + Inter body
    - Spacing: `app_spacing.dart` (`AppSpacing`) — 8pt grid, semantic aliases, border radii
    - Decorations: `app_decorations.dart` (`AppDecorations`) — card, input, sheet decorations + elevation shadows
    - Theme: `app_theme.dart` (`appTheme()`) — complete Material 3 `ThemeData`
    - **DO NOT** put theme code in `lib/app/` or scatter it across features.
    - **DO NOT** use `withOpacity()` — use pre-computed alpha values from `AppColors`.
4. **Path Conventions**:
    - Entities: `lib/core/entities/<entity>.dart`
    - Repositories (Interface): `lib/features/<feature>/domain/repositories/<name>_repository.dart`
    - Repositories (Impl): `lib/features/<feature>/data/repositories/<name>_repository_impl.dart`
    - BLoCs: `lib/features/<feature>/presentation/bloc/<name>_bloc.dart`
    - Events: `lib/features/<feature>/presentation/bloc/<name>_event.dart`
    - States: `lib/features/<feature>/presentation/bloc/<name>_state.dart`
    - Pages: `lib/features/<feature>/presentation/pages/<name>_page.dart`
    - Widgets: `lib/features/<feature>/presentation/widgets/<name>_widget.dart`
    - Data Sources: `lib/features/<feature>/data/datasources/<name>_local_datasource.dart`
    - Hive Models: `lib/features/<feature>/data/models/<name>_model.dart`
5. **Barrel Files**:
    - **DO**: Use `export` in each feature's main file for public APIs only.
    - **DO NOT**: Export internal implementation details.

## 2. Naming Conventions

Follow Dart standards strictly.

| Type | Convention | Example |
| :--- | :--- | :--- |
| **Files** | `snake_case` | `add_semester_page.dart` |
| **Classes** | `PascalCase` | `AddSemesterPage` |
| **Variables** | `camelCase` | `semesterName` |
| **BLoCs** | `PascalCase` + `Bloc` suffix | `AddSemesterBloc` |
| **Events** | `PascalCase` + `Event` suffix | `AddSemesterEvent` |
| **States** | `PascalCase` + `State` suffix | `AddSemesterState` |
| **Repositories** | `PascalCase` + `Repository` suffix | `SemesterRepository` |
| **Implementations** | `PascalCase` + `Impl` suffix | `SemesterRepositoryImpl` |

## 3. Logic Placement (Strict Boundaries)

- **Business Rules**: MUST reside in **Repository interfaces/implementations** or dedicated **Use Cases** (Domain/Data layer).
    - *Forbidden*: Placing GPA calculation logic, semester validation, or constraint enforcement in Widgets.
- **State Logic**: MUST reside in **BLoC classes**.
    - *Forbidden*: `setState` for state that a BLoC manages.
    - **Recommendation**: Pages should use `BlocBuilder` / `BlocConsumer` with state delegated to BLoCs.
- **Data Transformation**: MUST reside in **Repositories** (Data layer).
    - *Forbidden*: Parsing JSON, Hive records, or raw Maps in the UI or Domain layer.
    - **Pattern**: Repositories map data source responses to Domain entities.
- **Navigation Logic**: MUST use **GoRouter** with named routes.
    - *Forbidden*: `Navigator.push` with hardcoded widgets.
    - **Pattern**: Use `context.goNamed()` or `context.pushNamed()` with route constants.

## 4. State Management (BLoC)

### BLoC Pattern Rules

| Component | Convention |
| :--- | :--- |
| Events | Extend a sealed/abstract base event, use `Equatable` |
| States | Single state class with `Equatable` and `copyWith()` |
| BLoC | One BLoC per feature screen, injected via `BlocProvider` |
| Side effects | Use `BlocListener` (navigation, snackbars, dialogs) |
| UI rebuilds | Use `BlocBuilder` with `buildWhen` for performance |

### Rules

- **DO**: Use `Equatable` on all Events and States for proper equality comparison
- **DO**: Implement `copyWith()` that deep-copies mutable collections (Lists, Maps)
- **DO**: Inject repositories through BLoC constructors — never instantiate directly
- **DO**: Use `BlocProvider` at the widget tree level to scope BLoC lifecycle
- **DO NOT**: Use `clone()` that shares mutable references — this causes state mutation bugs
- **DO NOT**: Store `BuildContext` in BLoCs — it's a presentation concern
- **DO NOT**: Create custom "Provider" wrapper widgets that extend `BlocProvider`
- **DO NOT**: Use `static final` for repository instances in BLoCs

## 5. GPA Calculation Logic

GPA calculation is a core domain concern. The rules MUST be enforced at the **domain/data layer**, not the UI layer.

### Rules

- GPA conversion maps (grade → point value) live in `lib/core/constants/`
- SGPA and CGPA calculation functions live in `lib/core/utils/`
- UI must receive calculated values from the BLoC — never compute GPA in widgets
- Both 4.0 and 4.2 scales must be supported cleanly with the same interfaces
- Validation (empty course name, zero credit, etc.) is enforced in the domain layer

## 6. Local Database (Hive)

- All database operations go through repository implementations
- **DO NOT** access Hive directly from BLoCs or widgets
- Hive adapters for custom types must be registered at app startup
- All Hive boxes must be opened before use and properly closed on app termination
- Type adapters live alongside their Hive models in the data layer

## 7. Documentation

- **DO**: Add `///` doc comments on **all classes and methods** — public and private
- **DO**: Explain purpose, parameters, and return values
- **DO**: Only add inline comments when the WHY is non-obvious
- **DO NOT**: Leave TODO comments — implement fully or document limitations in PR description
- **DO NOT**: Reference tickets, issues, or callers in comments

## 8. Handling Ambiguity

If a user request is vague:

1. **STOP**: Do not guess domain fields or workflows.
2. **ANALYZE**: Refer to `docs/01-architecture-principles.md` or existing code.
3. **DOCUMENT**: If you must make an assumption, add a comment `// ASSUMPTION: <explanation>` and mention it in your summary.
4. **ASK**: Prefer asking the user for clarification on business rules.

## 9. Dependencies

- **DO NOT** add 3rd party packages without checking `lib/core/` and `pubspec.yaml` first
- **Approved packages** (current):
    - State Management: `flutter_bloc`, `bloc`
    - Database: `hive`, `hive_flutter`
    - Routing: `go_router`
    - Fonts: `google_fonts` (Inter Tight for headings, Inter for body)
    - SVG: `flutter_svg`
    - Icons: `lucide_icons` (primary), `cupertino_icons` (fallback)
    - Code Gen: `build_runner`, `hive_generator`
    - Launcher Icons: `flutter_launcher_icons`
    - Equality: `equatable`
- Adding packages outside this list requires user approval

## 10. Error Handling

- **Domain Failures**: Define custom `Failure` classes in `lib/core/errors/`
- **Data Errors**: Map database/cache exceptions to Domain failures in repositories
- **User Feedback**: BLoCs emit error states; UI displays snackbars or inline error widgets
- **Graceful Degradation**: The app must always remain usable even if data retrieval fails temporarily

## 11. Testing

- **Unit Tests**: Test GPA calculation, repositories, and BLoC logic
- **Widget Tests**: Test UI components with `WidgetTester`
- **Integration Tests**: Test full user flows (add semester → add courses → confirm → CGPA update)
- **Pattern**: Use `MockBloc` / `MockRepository` for dependency injection in tests
- **Critical Scenarios**:
    - GPA calculation accuracy for both 4.0 and 4.2 scales
    - Empty/zero credit handling
    - Semester add/edit/delete with correct CGPA recalculation
    - State immutability (no shared mutable references between states)

## 12. Theme Token Compliance

The V4 Editorial theme is implemented in `lib/theme/`. These files are the **single source of truth** for all visual tokens:

| File | Class | Contains |
|------|-------|----------|
| `app_colors.dart` | `AppColors` | Surface, brand, semantic, and derived tint colors |
| `app_typography.dart` | `AppTypography` | Inter Tight (headings) + Inter (body) text styles via `google_fonts` |
| `app_spacing.dart` | `AppSpacing` | 8pt spacing grid, semantic aliases, border radii |
| `app_decorations.dart` | `AppDecorations` | Card, input, sheet `BoxDecoration` constants + elevation shadows |
| `app_theme.dart` | `appTheme()` | Complete `ThemeData` wiring all tokens into Material 3 |

### Rules

- **DO NOT**: Use hardcoded colors like `Color(0xFF...)` — use `AppColors`
- **DO NOT**: Create custom `TextStyle(...)` — use `AppTypography`
- **DO NOT**: Hardcode spacing/padding values — use `AppSpacing`
- **DO NOT**: Use `withOpacity()` — use pre-computed alpha values from `AppColors` derived tints
- **DO NOT**: Use Montserrat — Inter Tight (headings) + Inter (body) via `google_fonts` are the only approved fonts
- **DO NOT**: Use glassmorphism / BackdropFilter — the Editorial design uses subtle borders and flat surfaces
- **DO NOT**: Use `new` keyword — unnecessary in Dart 2+
- **DO**: Use `AppDecorations.card` / `AppDecorations.cardFlat` for card styling
- **DO**: Use the app's defined color palette via token classes (`AppColors.accent` #2563EB, `AppColors.gpa` #F97316)
- **DO**: Follow the 8pt spacing grid (`AppSpacing.space8`, `AppSpacing.screenPadding`, etc.)
- **DO**: Use filled input style (`AppColors.surfaceMuted` bg, no border at rest, accent border when focused)
- **DO**: Use color-coded grade chips (A=accent, B=gpa/orange, C=surfaceMuted, D/F=error)
- **DO**: Use `abstract final class` for utility/token classes (not `abstract class`)

## 13. Git Rules for Agents

- **DO NOT** run `git commit` — the user owns commit authorship
- **DO NOT** run `git push` under any circumstances
- **DO NOT** run destructive git operations (`git reset --hard`, `git checkout -- <file>`, `git clean -f`)
- **DO NOT** modify `.gitignore`, pre-commit hooks, or CI workflows
- Report your changes via summary only; the user commits

## 14. Clean Code Principles

- Keep methods and classes focused and single-responsibility
- Use meaningful variable names that reflect intent
- Keep widget build methods concise; extract complex widgets to separate files
- Remove all debug `print()` statements — use the `Log` utility or remove entirely
- No `// ignore: must_be_immutable` — fix the root cause instead
- No `new` keyword — it's unnecessary in Dart 2+
- Use `const` constructors where possible
