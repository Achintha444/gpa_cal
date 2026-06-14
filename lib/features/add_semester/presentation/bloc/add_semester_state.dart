import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/subject.dart';

/// The save/loading status of the add-semester flow.
enum AddSemesterStatus {
  /// The form is open and editable.
  editing,

  /// The semester is currently being saved.
  saving,

  /// The semester was saved successfully.
  saved,

  /// An error occurred (validation or storage failure).
  error,
}

/// The state for [AddSemesterBloc].
///
/// Holds the current semester name, subject list, calculated SGPA, save
/// status, and any error message.
class AddSemesterState extends Equatable {
  /// The display name for the semester being created.
  final String semesterName;

  /// The list of subjects currently in the form.
  final List<Subject> subjects;

  /// The live SGPA calculated from the current [subjects].
  final double sgpa;

  /// The GPA scale type: `0` for 4.0 scale, `1` for 4.2 scale.
  final int gpaType;

  /// The current save/loading status.
  final AddSemesterStatus status;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates an [AddSemesterState].
  const AddSemesterState({
    this.semesterName = '',
    this.subjects = const [],
    this.sgpa = 0.0,
    this.gpaType = 0,
    this.status = AddSemesterStatus.editing,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [
        semesterName,
        subjects,
        sgpa,
        gpaType,
        status,
        errorMessage,
      ];

  /// Creates a copy of this state with the given fields replaced.
  ///
  /// Deep-copies [subjects] to prevent shared-reference mutations.
  AddSemesterState copyWith({
    String? semesterName,
    List<Subject>? subjects,
    double? sgpa,
    int? gpaType,
    AddSemesterStatus? status,
    String? errorMessage,
  }) {
    return AddSemesterState(
      semesterName: semesterName ?? this.semesterName,
      subjects:
          subjects != null ? List.of(subjects) : List.of(this.subjects),
      sgpa: sgpa ?? this.sgpa,
      gpaType: gpaType ?? this.gpaType,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
