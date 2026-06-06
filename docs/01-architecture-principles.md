# GPA Cal — Architecture Principles

This document is the **AUTHORITATIVE** source of truth for the GPA Cal app architecture.
All agents and engineers must adhere strictly to these principles. Deviations are interpreted as errors.

## 1. High-Level Architecture

The GPA Cal app follows **Clean Architecture** with a feature-first folder structure.
Dependencies flow **inwards** towards the Domain.

```
lib/
├── app/                           # App entry point, router
│   ├── app.dart                   # Root MaterialApp with GoRouter
│   └── router.dart                # GoRouter configuration with named routes
├── theme/                         # Theme tokens and styled decorations
│   ├── app_colors.dart            # Color palette tokens
│   ├── app_typography.dart        # Typography scale tokens
│   ├── app_spacing.dart           # Spacing and border radius tokens
│   ├── app_decorations.dart       # Glassmorphism, card shadows, container styles
│   └── app_theme.dart             # ThemeData built from tokens
├── core/                          # Shared domain entities, utilities, base classes
│   ├── entities/                  # Shared domain entities (Subject, Semester, UserResult, UserDetails)
│   ├── constants/                 # GPA conversion tables, cache keys, app constants
│   ├── errors/                    # Custom Failure classes (CacheFailure, ValidationFailure, etc.)
│   ├── extensions/                # Dart/Flutter extensions
│   └── utils/                     # GPA calculation, input formatters, logging
├── shared/                        # Cross-feature reusable widgets (non-feature-specific)
│   └── widgets/                   # GlassEffect, CustomAppBar, MainButton, AlertDialogs, LoadingScreen
└── features/                      # Feature modules (vertical slices)
    ├── splash/                    # Splash screen + first-time detection
    │   ├── domain/
    │   │   └── repositories/
    │   ├── data/
    │   │   ├── datasources/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    ├── onboarding/                # First-time user registration (name, university, GPA type)
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    ├── home/                      # Main dashboard (CGPA card + semester list)
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    ├── add_semester/               # Add new semester with courses
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    └── edit_semester/              # Edit existing semester
        ├── domain/
        ├── data/
        └── presentation/
```

## 2. Layer Responsibilities

### 2.1 Shared Domain Entities (`core/entities/`)

/// Pure Dart immutable models shared across all features.

- **Role**: Define the core data structures of the application.
- **Contains**: `Subject`, `Semester`, `UserResult`, `UserDetails`, and other domain entities used by multiple features.
- **RESTRICTION**: NO Flutter dependencies. NO database imports. NO third-party packages (except `equatable`).
- **WHY**: Entities like `Semester` are used by home, add_semester, edit_semester, and potentially future features. Centralizing them eliminates duplication and drift risk.
- **Pattern**: All entities use `Equatable` for value equality and provide `copyWith()` methods.

```dart
/// Represents a single academic course with its grade and credit weight.
///
/// Used across semester creation, editing, and GPA calculation flows.
class Subject extends Equatable {
  /// The name of the course (e.g., "Data Structures").
  final String course;

  /// The letter grade received (e.g., "A+", "B-").
  final String result;

  /// The credit hours for this course.
  final double credit;

  const Subject({
    required this.course,
    required this.result,
    required this.credit,
  });

  @override
  List<Object?> get props => [course, result, credit];

  /// Creates a copy of this [Subject] with the given fields replaced.
  Subject copyWith({String? course, String? result, double? credit}) {
    return Subject(
      course: course ?? this.course,
      result: result ?? this.result,
      credit: credit ?? this.credit,
    );
  }
}
```

### 2.2 Feature Domain Layer (`domain/`)

/// Feature-specific business logic. Pure Dart.

- **Role**: Define repository contracts that the data layer must fulfill.
- **Contains**:
    - **Repository Interfaces**: Abstract contracts for data access
- **RESTRICTION**: NO Flutter dependencies. NO database imports. NO third-party packages (except `equatable`).
- **NOTE**: Entities live in `core/entities/`, NOT in feature `domain/` folders.

```dart
/// Contract for semester data operations.
///
/// Implemented by [SemesterRepositoryImpl] in the data layer.
abstract class SemesterRepository {
  /// Retrieves all semesters and the cumulative result for the current user.
  ///
  /// Throws [CacheFailure] if the local data store is inaccessible.
  Future<UserResult> getUserResults();

  /// Adds a new [semester] and recalculates the cumulative GPA.
  ///
  /// Returns the updated [UserResult] after the semester is persisted.
  /// Throws [CacheFailure] on storage failure.
  Future<UserResult> addSemester(Semester semester);

  /// Removes the given [semester] and recalculates the cumulative GPA.
  ///
  /// Throws [CacheFailure] on storage failure.
  Future<void> deleteSemester(Semester semester);
}
```

### 2.3 Data Layer (`data/`)

/// Concrete implementations of domain contracts.

- **Role**: Handle all data persistence and transformation.
- **Contains**:
    - **Data Sources**: Direct access to Hive boxes
    - **Models**: Hive-annotated classes with `TypeAdapter` serialization
    - **Repository Implementations**: Implement domain interfaces, handle data transformation
- **RESTRICTION**: NO UI code. NO BLoC/state management code.
- **Pattern**: Repositories map Hive models to domain entities and vice versa.

```dart
/// Hive data model for [Subject] entity persistence.
///
/// Maps to/from the domain [Subject] entity in the repository layer.
@HiveType(typeId: 0)
class SubjectModel extends HiveObject {
  @HiveField(0)
  late String course;

  @HiveField(1)
  late String result;

  @HiveField(2)
  late double credit;

  /// Converts this Hive model to a domain [Subject] entity.
  Subject toEntity() => Subject(course: course, result: result, credit: credit);

  /// Creates a [SubjectModel] from a domain [Subject] entity.
  static SubjectModel fromEntity(Subject subject) {
    return SubjectModel()
      ..course = subject.course
      ..result = subject.result
      ..credit = subject.credit;
  }
}
```

### 2.4 Presentation Layer (`presentation/`)

/// UI and state management.

- **Role**: Handle user interaction, display data, and manage screen state.
- **Contains**:
    - **BLoCs**: State management using flutter_bloc
    - **Pages**: Full-screen widgets (route destinations)
    - **Widgets**: Reusable UI components within the feature
- **RESTRICTION**: NO direct database access. NO business logic (delegate to repositories/use cases).

## 3. Dependency Direction & Boundaries

```
Presentation → Domain ← Data

Widget → BlocBuilder → BLoC → Repository(interface)
                                       ↑
                                 RepositoryImpl → HiveDataSource
```

1. **Domain Independence**: The domain layer knows NOTHING about the outer layers. It defines *what* needs to be done, not *how*.
2. **Shared Entities**: All domain entities live in `core/entities/` and are accessible by all features. This is the single source of truth for domain models.
3. **UI → Domain**: Presentation depends on domain for entities (via `core/entities/`) and repository contracts.
4. **Data → Domain**: Data implements domain repository interfaces. It does NOT know about the UI.
5. **Theme → UI**: All features import from `theme/` for tokens. Never hardcode visual values.
6. **No Cross-Feature Imports**: Features MUST NOT import from other features directly.
    - Exception: Shared packages (`core/`, `theme/`, `shared/`) are always accessible.
    - Cross-feature communication happens through shared state or GoRouter navigation with parameters.

## 4. State Management (BLoC)

### 4.1 BLoC Organization

/// BLoCs are defined within their feature's `presentation/bloc/` directory.

Each feature screen gets one BLoC with:
- A sealed/abstract base **Event** class with concrete event subclasses
- A single **State** class using `Equatable` with `copyWith()`
- The **BLoC** class that maps events to state transitions

```dart
/// Events for the home screen.
sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered on initial load to fetch user results from storage.
final class HomeLoadRequested extends HomeEvent {}

/// Triggered when the user requests to delete a [semester].
final class HomeSemesterDeleted extends HomeEvent {
  final Semester semester;
  const HomeSemesterDeleted(this.semester);

  @override
  List<Object?> get props => [semester];
}
```

```dart
/// Represents the possible states of the home screen.
enum HomeStatus { initial, loading, loaded, error }

/// State for the home screen.
///
/// Contains the user's cumulative result data and the current loading status.
class HomeState extends Equatable {
  final HomeStatus status;
  final UserResult? userResult;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.userResult,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, userResult, errorMessage];

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Deep-copies any mutable collections to prevent shared-reference bugs.
  HomeState copyWith({
    HomeStatus? status,
    UserResult? userResult,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      userResult: userResult ?? this.userResult,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
```

```dart
/// Manages the state of the home screen.
///
/// Fetches user results on initialization and handles semester deletion.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// The repository used for data access operations.
  final SemesterRepository _semesterRepository;

  /// Creates a [HomeBloc] with the given [semesterRepository].
  HomeBloc({required SemesterRepository semesterRepository})
      : _semesterRepository = semesterRepository,
        super(const HomeState()) {
    on<HomeLoadRequested>(_onLoadRequested);
    on<HomeSemesterDeleted>(_onSemesterDeleted);
  }

  /// Handles the initial data load event.
  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final UserResult userResult = await _semesterRepository.getUserResults();
      emit(state.copyWith(status: HomeStatus.loaded, userResult: userResult));
    } on CacheFailure catch (e) {
      emit(state.copyWith(status: HomeStatus.error, errorMessage: e.message));
    }
  }
}
```

### 4.2 BLoC Lifecycle

- **`BlocProvider`**: Used at the widget tree level to scope BLoC lifecycle to a route
- **Constructor injection**: Repositories passed via constructor, NOT instantiated as static finals
- **`BlocBuilder`**: For UI rebuilds, with `buildWhen` to optimize rebuilds
- **`BlocListener`**: For side effects (navigation, snackbars, dialogs)
- **`MultiBlocListener`**: When a screen needs multiple side-effect listeners

### 4.3 State Immutability

**CRITICAL**: All State classes must be truly immutable.

- Use `Equatable` for value-based equality
- Use `copyWith()` that creates NEW collections, not shared references
- Never mutate a Map or List that belongs to a state object
- Use `List.of()` / `Map.of()` / spread operators to create copies

```dart
/// CORRECT — creates a new list
emit(state.copyWith(
  semesters: [...state.semesters, newSemester],
));

/// WRONG — mutates the existing list (breaks BLoC equality checks)
state.semesters.add(newSemester);
emit(state);
```

## 5. Local Database (Hive)

### 5.1 Data Access Pattern

```
Widget → BlocBuilder → BLoC → Repository (interface) → RepositoryImpl → Hive Box
```

- Repositories return **domain entities**, never Hive models
- Model ↔ Entity mapping happens inside the repository implementation
- All database operations are async
- Hive boxes are opened at app startup and closed on termination

### 5.2 Hive Setup

/// All Hive type adapters are registered in a single initialization function called from `main()`.

```dart
/// Initializes Hive and registers all type adapters.
///
/// Must be called before `runApp()` in `main()`.
Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(SemesterModelAdapter());
  Hive.registerAdapter(UserDetailsModelAdapter());
  Hive.registerAdapter(UserResultModelAdapter());
}
```

### 5.3 Migration from SharedPreferences

- Existing SharedPreferences data should be migrated to Hive on first launch after upgrade
- The migration runs once and sets a `migrated` flag in Hive
- If migration fails, the app falls back to SharedPreferences gracefully

## 6. Routing (GoRouter)

### 6.1 Route Structure

/// All routes are defined in `app/router.dart` with named constants.

```dart
/// Application route configuration.
///
/// Defines all navigation paths and handles first-launch redirect to onboarding.
final GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add-semester/:name',
      name: 'addSemester',
      builder: (context, state) {
        final String name = state.pathParameters['name']!;
        return AddSemesterPage(semesterName: name);
      },
    ),
    GoRoute(
      path: '/edit-semester/:hash',
      name: 'editSemester',
      builder: (context, state) {
        final String hash = state.pathParameters['hash']!;
        return EditSemesterPage(semesterHash: hash);
      },
    ),
  ],
);
```

### 6.2 Navigation Rules

- Use named routes exclusively: `context.goNamed('home')`
- Route path constants live in `app/router.dart`
- Use `context.goNamed()` for replacement navigation (splash → home)
- Use `context.pushNamed()` for stack navigation (home → add semester)
- Pass data via path parameters or extra, not constructor injection through widget wrappers

## 7. GPA Calculation

### 7.1 Core Logic

/// GPA conversion tables and calculation functions live in `core/`.

```dart
/// Provides GPA conversion tables and calculation utilities.
///
/// Supports two grading scales:
/// - 4.0 scale (gpaType = 0): Standard scale used by most universities
/// - 4.2 scale (gpaType = 1): Extended scale where A+ = 4.2
abstract class GpaCalculator {
  /// Calculates the Semester GPA for a list of [subjects] using the given [gpaType].
  ///
  /// Returns 0.0 if total credits are zero.
  static double calculateSgpa(List<Subject> subjects, int gpaType) { ... }

  /// Calculates the Cumulative GPA from total weighted result and total credits.
  ///
  /// Returns 0.0 if [totalCredit] is zero to avoid division by zero.
  static double calculateCgpa(double totalResult, double totalCredit) { ... }
}
```

### 7.2 Conversion Tables

- Grade-to-point mappings are defined as `const` Maps in `core/constants/gpa_tables.dart`
- Result lists (valid grades) are defined alongside the maps
- Both are keyed by `gpaType` (0 or 1) for clean access

## 8. Feature Isolation

### 8.1 Zero Cross-Feature Imports

```dart
/// FORBIDDEN — importing from another feature
import 'package:gpa_cal/features/home/presentation/bloc/home_bloc.dart';
// inside features/add_semester/

/// ALLOWED — shared entities from core
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// ALLOWED — theme tokens
import 'package:gpa_cal/theme/app_colors.dart';
import 'package:gpa_cal/theme/app_spacing.dart';

/// ALLOWED — shared widgets
import 'package:gpa_cal/shared/widgets/glass_effect.dart';
import 'package:gpa_cal/shared/widgets/custom_app_bar.dart';
```

### 8.2 Shared Widgets

/// Widgets reused across 2+ features belong in `lib/shared/widgets/`.

Current shared widgets:
- `GlassEffect` — glassmorphism container with configurable blur and gradient
- `CustomAppBar` — app bar with welcome text and university info
- `GpaCalMainButton` — primary action button with glass effect
- `CustomAlertDialog` — confirmation dialog for destructive actions
- `LoadingScreen` — animated loading indicator
- `ErrorAnimatedWidget` — slide-in error message animation

Feature-specific widgets stay in `features/<feature>/presentation/widgets/`.

## 9. Shared Widgets Documentation

/// All shared widgets must have comprehensive doc comments explaining:

- What the widget does
- Required and optional parameters
- Usage example in a doc comment

```dart
/// A glassmorphism container with configurable blur, gradient, and border.
///
/// Used throughout the app for cards, dialogs, and buttons to maintain
/// the frosted-glass visual language.
///
/// Example:
/// ```dart
/// GlassEffect(
///   height: 216,
///   width: 216,
///   topColorOpacity: 0.4,
///   child: Image.asset('graphics/logo.png'),
/// )
/// ```
class GlassEffect extends StatelessWidget {
  /// The child widget displayed inside the glass container.
  final Widget child;

  /// The fixed height of the glass container.
  final double height;

  /// The fixed width of the glass container.
  final double width;

  /// Opacity of the top gradient color. Defaults to 0.3.
  final double topColorOpacity;

  // ...
}
```

## 10. Error Handling

### 10.1 Failure Classes

/// Custom failure types in `core/errors/`.

```dart
/// Base class for all domain-level failures.
///
/// Subclasses represent specific failure categories that the UI layer
/// can handle with appropriate user feedback.
abstract class Failure extends Equatable {
  /// A human-readable message describing the failure.
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Thrown when local storage operations fail.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to access local storage']);
}

/// Thrown when data validation fails.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Invalid data']);
}
```

### 10.2 UI Error Handling

- BLoCs emit states with `status: error` and an `errorMessage`
- UI uses `BlocListener` to show snackbars for transient errors
- UI uses `BlocBuilder` to show error widgets with retry for persistent errors
- Every screen handles the error state — no silent failures

## 11. Testing Strategy

### 11.1 Test Structure

```
test/
├── core/
│   └── utils/
│       └── gpa_calculator_test.dart
├── features/
│   ├── home/
│   │   ├── data/
│   │   │   └── repositories/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── widgets/
│   ├── add_semester/
│   └── edit_semester/
└── shared/
    └── widgets/
```

### 11.2 Critical Test Scenarios

- **GPA calculation accuracy**: Both 4.0 and 4.2 scales with known inputs/outputs
- **Zero credit handling**: Division by zero protection
- **State immutability**: Verify that state transitions create new objects, not mutations
- **Semester CRUD**: Add/edit/delete with correct CGPA recalculation
- **Empty states**: App behavior with no semesters, no courses
- **Error recovery**: BLoC error states with retry

## 12. Performance Targets

- **App launch → interactive**: < 2 seconds
- **Semester add/edit/delete**: < 200ms perceived latency
- **Animation frame rate**: Consistent 60fps for glassmorphism effects
- **Database query**: < 100ms for data load
- **App size**: < 30MB (release APK)
