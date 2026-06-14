import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/semester.dart';

/// The loading status of the semester detail screen.
enum SemesterDetailStatus {
  /// The initial state before the semester has been requested.
  initial,

  /// The semester is currently being loaded.
  loading,

  /// The semester was found and loaded successfully.
  success,

  /// The semester could not be found or an error occurred.
  error,
}

/// The state for [SemesterDetailBloc].
///
/// Holds the loaded [Semester] alongside the current [SemesterDetailStatus]
/// and any error message.
class SemesterDetailState extends Equatable {
  /// The current loading status.
  final SemesterDetailStatus status;

  /// The loaded semester. Null until the status is [SemesterDetailStatus.success].
  final Semester? semester;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates a [SemesterDetailState].
  const SemesterDetailState({
    this.status = SemesterDetailStatus.initial,
    this.semester,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, semester, errorMessage];

  /// Creates a copy of this state with the given fields replaced.
  SemesterDetailState copyWith({
    SemesterDetailStatus? status,
    Semester? semester,
    String? errorMessage,
  }) {
    return SemesterDetailState(
      status: status ?? this.status,
      semester: semester ?? this.semester,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
