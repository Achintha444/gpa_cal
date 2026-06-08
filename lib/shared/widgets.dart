/// Barrel file for cross-feature shared widgets.
///
/// Widgets in `lib/shared/widgets/` are reused across two or more features.
/// Export them here so feature code can import a single path:
/// ```dart
/// import 'package:gpa_cal/shared/widgets.dart';
/// ```
///
/// As shared widgets are implemented, add an export line for each:
/// ```dart
/// export 'package:gpa_cal/shared/widgets/custom_app_bar.dart';
/// export 'package:gpa_cal/shared/widgets/main_button.dart';
/// export 'package:gpa_cal/shared/widgets/loading_screen.dart';
/// ```
///
/// Feature-specific widgets belong in
/// `lib/features/<feature>/presentation/widgets/` — not here.
library shared_widgets;
