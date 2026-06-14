import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/utils/gpa_calculator.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/edit_semester/presentation/bloc/edit_semester_event.dart';
import 'package:gpa_cal/features/edit_semester/presentation/bloc/edit_semester_state.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Manages the state for the edit-semester form screen.
///
/// Loads the existing semester data on [EditSemesterInitialized], handles
/// course CRUD operations with live SGPA recalculation, tracks unsaved changes,
/// persists edits via [SemesterRepository.editSemester], and deletes the
/// semester via [SemesterRepository.deleteSemester].
class EditSemesterBloc extends Bloc<EditSemesterEvent, EditSemesterState> {
  /// Logger for this BLoC.
  static final Log _log = Log('EditSemesterBloc');

  /// Repository for reading, editing, and deleting semester data.
  final SemesterRepository _semesterRepository;

  /// The default subject added when the user taps "+ Add Another Course".
  static const Subject _defaultSubject = Subject(
    courseName: '',
    grade: 'A+',
    credit: 3.0,
  );

  /// Creates an [EditSemesterBloc] with the given [semesterRepository].
  EditSemesterBloc({required SemesterRepository semesterRepository})
      : _semesterRepository = semesterRepository,
        super(const EditSemesterState()) {
    on<EditSemesterInitialized>(_onInitialized);
    on<SemesterNameChanged>(_onSemesterNameChanged);
    on<CourseUpdated>(_onCourseUpdated);
    on<CourseAdded>(_onCourseAdded);
    on<CourseDeleted>(_onCourseDeleted);
    on<SemesterSaved>(_onSemesterSaved);
    on<SemesterDeleteRequested>(_onSemesterDeleteRequested);
  }

  /// Handles [EditSemesterInitialized] — loads the semester by hash.
  ///
  /// Emits [EditSemesterStatus.loading] while loading, then
  /// [EditSemesterStatus.editing] with pre-populated form data, or
  /// [EditSemesterStatus.error] if the semester is not found.
  Future<void> _onInitialized(
    EditSemesterInitialized event,
    Emitter<EditSemesterState> emit,
  ) async {
    emit(state.copyWith(status: EditSemesterStatus.loading));

    try {
      final UserResult userResult = await _semesterRepository.getUserResult();

      final Semester? semester = userResult.semesters.where(
        (Semester s) => s.hash == event.hash,
      ).firstOrNull;

      if (semester == null) {
        _log.e(
          'EditSemesterInitialized: no semester for hash=${event.hash}',
        );
        emit(state.copyWith(
          status: EditSemesterStatus.error,
          errorMessage: 'Semester not found.',
        ));
        return;
      }

      _log.d(
        'EditSemesterInitialized: loaded "${semester.name}" '
        'with ${semester.subjectList.length} courses, gpaType=${event.gpaType}',
      );

      emit(state.copyWith(
        semesterHash: semester.hash,
        semesterName: semester.name,
        subjects: List.of(semester.subjectList),
        sgpa: semester.sgpa,
        gpaType: event.gpaType,
        hasChanges: false,
        status: EditSemesterStatus.editing,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('EditSemesterInitialized failed: $e');
      emit(state.copyWith(
        status: EditSemesterStatus.error,
        errorMessage: 'Failed to load semester. Please try again.',
      ));
    }
  }

  /// Handles [SemesterNameChanged] — updates the semester name and marks changes.
  void _onSemesterNameChanged(
    SemesterNameChanged event,
    Emitter<EditSemesterState> emit,
  ) {
    emit(state.copyWith(
      semesterName: event.name,
      hasChanges: true,
    ));
  }

  /// Handles [CourseUpdated] — replaces the subject at [event.index] and
  /// recalculates the live SGPA.
  void _onCourseUpdated(
    CourseUpdated event,
    Emitter<EditSemesterState> emit,
  ) {
    final List<Subject> updated = List.of(state.subjects);
    if (event.index < 0 || event.index >= updated.length) return;
    updated[event.index] = event.subject;

    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: updated,
      gpaType: state.gpaType,
    );

    emit(state.copyWith(subjects: updated, sgpa: sgpa, hasChanges: true));
  }

  /// Handles [CourseAdded] — appends a new default course to the list.
  void _onCourseAdded(
    CourseAdded event,
    Emitter<EditSemesterState> emit,
  ) {
    final List<Subject> updated = List.of(state.subjects)
      ..add(_defaultSubject);

    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: updated,
      gpaType: state.gpaType,
    );

    emit(state.copyWith(subjects: updated, sgpa: sgpa, hasChanges: true));
  }

  /// Handles [CourseDeleted] — removes the subject at [event.index].
  ///
  /// Emits an error state if only one course remains.
  void _onCourseDeleted(
    CourseDeleted event,
    Emitter<EditSemesterState> emit,
  ) {
    if (state.subjects.length <= 1) {
      emit(state.copyWith(
        status: EditSemesterStatus.error,
        errorMessage: 'A semester must have at least one course.',
      ));
      return;
    }

    final List<Subject> updated = List.of(state.subjects)
      ..removeAt(event.index);

    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: updated,
      gpaType: state.gpaType,
    );

    emit(state.copyWith(
      subjects: updated,
      sgpa: sgpa,
      hasChanges: true,
      status: EditSemesterStatus.editing,
      errorMessage: '',
    ));
  }

  /// Handles [SemesterSaved] — persists the edited semester.
  ///
  /// Recalculates totals, builds a new [Semester] entity with the original
  /// hash, and calls [SemesterRepository.editSemester].
  Future<void> _onSemesterSaved(
    SemesterSaved event,
    Emitter<EditSemesterState> emit,
  ) async {
    emit(state.copyWith(status: EditSemesterStatus.saving));

    try {
      double totalResult = 0.0;
      double totalCredit = 0.0;

      for (final Subject subject in state.subjects) {
        final double gradePoint =
            GpaCalculator.gradePointFor(subject.grade, state.gpaType);
        totalResult += gradePoint * subject.credit;
        totalCredit += subject.credit;
      }

      final double sgpa = GpaCalculator.calculateSgpa(
        subjects: state.subjects,
        gpaType: state.gpaType,
      );

      final Semester updated = Semester(
        hash: state.semesterHash,
        name: state.semesterName.trim().isEmpty
            ? 'Semester'
            : state.semesterName.trim(),
        sgpa: sgpa,
        totalResult: totalResult,
        totalCredit: totalCredit,
        subjectList: List.of(state.subjects),
      );

      await _semesterRepository.editSemester(updated);
      _log.d(
        'SemesterSaved: updated "${updated.name}" with SGPA ${updated.sgpa}',
      );

      emit(state.copyWith(
        status: EditSemesterStatus.saved,
        sgpa: sgpa,
        hasChanges: false,
      ));
    } catch (e) {
      _log.e('SemesterSaved failed: $e');
      emit(state.copyWith(
        status: EditSemesterStatus.error,
        errorMessage: 'Failed to save changes. Please try again.',
      ));
    }
  }

  /// Handles [SemesterDeleteRequested] — deletes the current semester.
  ///
  /// Emits [EditSemesterStatus.deleted] on success.
  Future<void> _onSemesterDeleteRequested(
    SemesterDeleteRequested event,
    Emitter<EditSemesterState> emit,
  ) async {
    emit(state.copyWith(status: EditSemesterStatus.saving));

    try {
      await _semesterRepository.deleteSemester(state.semesterHash);
      _log.d(
        'SemesterDeleteRequested: deleted semester hash=${state.semesterHash}',
      );

      emit(state.copyWith(status: EditSemesterStatus.deleted));
    } catch (e) {
      _log.e('SemesterDeleteRequested failed: $e');
      emit(state.copyWith(
        status: EditSemesterStatus.error,
        errorMessage: 'Failed to delete semester. Please try again.',
      ));
    }
  }
}
