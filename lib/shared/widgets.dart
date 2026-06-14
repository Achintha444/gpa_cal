/// Barrel file for cross-feature shared widgets.
///
/// Widgets in `lib/shared/widgets/` are reused across two or more features.
/// Import this single path from any feature:
/// ```dart
/// import 'package:gpa_cal/shared/widgets.dart';
/// ```
///
/// Feature-specific widgets belong in
/// `lib/features/<feature>/presentation/widgets/` — not here.
library shared_widgets;

export 'package:gpa_cal/shared/widgets/bottom_nav_shell.dart';
export 'package:gpa_cal/shared/widgets/course_entry_card.dart';
export 'package:gpa_cal/shared/widgets/credit_stepper.dart';
export 'package:gpa_cal/shared/widgets/empty_state_view.dart';
export 'package:gpa_cal/shared/widgets/grade_chip_selector.dart';
export 'package:gpa_cal/shared/widgets/semester_card.dart';
export 'package:gpa_cal/shared/widgets/sgpa_bar.dart';
export 'package:gpa_cal/shared/widgets/step_indicator.dart';
