import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// The loading/save status of the edit-semester flow.
enum EditSemesterStatus {
  /// The screen is loading the original semester data.
  loading,

  /// The form is open and editable.
  editing,

  /// Changes are currently being saved.
  saving,

  /// Changes were saved successfully.
  saved,

  /// The semester was deleted successfully.
  deleted,

  /// An error occurred during load, save, or delete.
  error,
}

/// The state for [EditSemesterBloc].
///
/// Holds the current semester name, subject list, calculated SGPA, change
/// tracking flag, save status, and any error message.
class EditSemesterState extends Equatable {
  /// The unique hash of the semester being edited.
  final int semesterHash;

  /// The current display name for the semester.
  final String semesterName;

  /// The list of subjects currently in the form.
  final List<Subject> subjects;

  /// The live SGPA calculated from the current [subjects].
  final double sgpa;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// Whether the user has made any changes since the form was loaded.
  final bool hasChanges;

  /// The current save/loading status.
  final EditSemesterStatus status;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates an [EditSemesterState].
  const EditSemesterState({
    this.semesterHash = 0,
    this.semesterName = '',
    this.subjects = const [],
    this.sgpa = 0.0,
    this.gpaType = 0,
    this.hasChanges = false,
    this.status = EditSemesterStatus.loading,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        semesterHash,
        semesterName,
        subjects,
        sgpa,
        gpaType,
        hasChanges,
        status,
        errorMessage,
      ];

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Deep-copies [subjects] to prevent shared-reference mutations.
  EditSemesterState copyWith({
    int? semesterHash,
    String? semesterName,
    List<Subject>? subjects,
    double? sgpa,
    int? gpaType,
    bool? hasChanges,
    EditSemesterStatus? status,
    String? errorMessage,
  }) {
    return EditSemesterState(
      semesterHash: semesterHash ?? this.semesterHash,
      semesterName: semesterName ?? this.semesterName,
      subjects:
          subjects != null ? List.of(subjects) : List.of(this.subjects),
      sgpa: sgpa ?? this.sgpa,
      gpaType: gpaType ?? this.gpaType,
      hasChanges: hasChanges ?? this.hasChanges,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
