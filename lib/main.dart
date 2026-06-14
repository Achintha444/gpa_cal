import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:gpa_cal/app/app.dart';
import 'package:gpa_cal/core/constants/cache_keys.dart';
import 'package:gpa_cal/features/onboarding/data/models/user_details_model.dart';
import 'package:gpa_cal/features/semester/data/models/semester_model.dart';
import 'package:gpa_cal/features/semester/data/models/subject_model.dart';
import 'package:gpa_cal/features/semester/data/models/user_result_model.dart';

/// Entry point for GPA Cal.
///
/// Performs the following startup sequence before launching the app:
/// 1. Initialises Flutter bindings.
/// 2. Locks orientation to portrait.
/// 3. Initialises Hive and registers all type adapters.
/// 4. Opens all required Hive boxes.
/// 5. Launches [GpaCalApp].
///
/// Adapters MUST be registered before boxes are opened — order matters.
/// Adapter typeIds must match the `@HiveType(typeId: n)` on each model.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restrict the app to portrait orientations.
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialise Hive for Flutter (uses the app documents directory).
  await Hive.initFlutter();

  // Register type adapters — SubjectModel (1) before SemesterModel (0)
  // because SemesterModel contains a List<SubjectModel>.
  // UserResultModel (3) depends on SemesterModel (0), so register in dependency order.
  Hive.registerAdapter(SubjectModelAdapter());
  Hive.registerAdapter(SemesterModelAdapter());
  Hive.registerAdapter(UserDetailsModelAdapter());
  Hive.registerAdapter(UserResultModelAdapter());

  // Open boxes — must be done after adapters are registered.
  await Hive.openBox<UserDetailsModel>(CacheKeys.hiveUserDetailsBox);
  await Hive.openBox<UserResultModel>(CacheKeys.hiveUserResultBox);

  runApp(const GpaCalApp());
}
