import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/core/utils/gpa_calculator.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/add_semester/presentation/bloc/add_semester_event.dart';
import 'package:gpa_cal/features/add_semester/presentation/bloc/add_semester_state.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Manages the state for the add-semester form screen.
///
/// Handles course CRUD operations, live SGPA recalculation, and final
/// semester persistence. All GPA calculation is delegated to [GpaCalculator].
class AddSemesterBloc extends Bloc<AddSemesterEvent, AddSemesterState> {
  /// Logger for this BLoC.
  static final Log _log = Log('AddSemesterBloc');

  /// Repository for persisting the new semester.
  final SemesterRepository _semesterRepository;

  /// The default subject added when the form initialises or a course is added.
  static const Subject _defaultSubject = Subject(
    courseName: '',
    grade: 'A+',
    credit: 3.0,
  );

  /// Creates an [AddSemesterBloc] with the given [semesterRepository].
  AddSemesterBloc({required SemesterRepository semesterRepository})
      : _semesterRepository = semesterRepository,
        super(const AddSemesterState()) {
    on<AddSemesterInitialized>(_onInitialized);
    on<CourseUpdated>(_onCourseUpdated);
    on<CourseAdded>(_onCourseAdded);
    on<CourseDeleted>(_onCourseDeleted);
    on<SemesterConfirmed>(_onSemesterConfirmed);
  }

  /// Handles [AddSemesterInitialized] — sets the semester name, GPA type, and
  /// populates the initial default course.
  void _onInitialized(
    AddSemesterInitialized event,
    Emitter<AddSemesterState> emit,
  ) {
    final List<Subject> initialSubjects = [_defaultSubject];
    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: initialSubjects,
      gpaType: event.gpaType,
    );

    emit(state.copyWith(
      semesterName: event.name,
      gpaType: event.gpaType,
      subjects: initialSubjects,
      sgpa: sgpa,
      status: AddSemesterStatus.editing,
      errorMessage: '',
    ));
  }

  /// Handles [CourseUpdated] — replaces the subject at [event.index] and
  /// recalculates the live SGPA.
  void _onCourseUpdated(
    CourseUpdated event,
    Emitter<AddSemesterState> emit,
  ) {
    final List<Subject> updated = List.of(state.subjects);
    if (event.index < 0 || event.index >= updated.length) return;
    updated[event.index] = event.subject;

    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: updated,
      gpaType: state.gpaType,
    );

    emit(state.copyWith(subjects: updated, sgpa: sgpa));
  }

  /// Handles [CourseAdded] — appends a new default course to the list.
  void _onCourseAdded(
    CourseAdded event,
    Emitter<AddSemesterState> emit,
  ) {
    final List<Subject> updated = List.of(state.subjects)
      ..add(_defaultSubject);

    final double sgpa = GpaCalculator.calculateSgpa(
      subjects: updated,
      gpaType: state.gpaType,
    );

    emit(state.copyWith(subjects: updated, sgpa: sgpa));
  }

  /// Handles [CourseDeleted] — removes the subject at [event.index].
  ///
  /// Emits an error state if only one course remains; at least one course is
  /// required to create a semester.
  void _onCourseDeleted(
    CourseDeleted event,
    Emitter<AddSemesterState> emit,
  ) {
    if (state.subjects.length <= 1) {
      emit(state.copyWith(
        status: AddSemesterStatus.error,
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
      status: AddSemesterStatus.editing,
      errorMessage: '',
    ));
  }

  /// Handles [SemesterConfirmed] — builds the [Semester] entity, persists it,
  /// and emits [AddSemesterStatus.saved] on success.
  Future<void> _onSemesterConfirmed(
    SemesterConfirmed event,
    Emitter<AddSemesterState> emit,
  ) async {
    emit(state.copyWith(status: AddSemesterStatus.saving));

    try {
      double totalResult = 0.0;
      double totalCredit = 0.0;

      for (final Subject subject in state.subjects) {
        final double gradePoint =
            GpaCalculator.gradePointFor(subject.grade, state.gpaType);
        totalResult += gradePoint * subject.credit;
        totalCredit += subject.credit;
      }

      final Semester semester = Semester(
        hash: DateTime.now().millisecondsSinceEpoch,
        name: state.semesterName.trim().isEmpty
            ? 'Semester'
            : state.semesterName.trim(),
        sgpa: state.sgpa,
        totalResult: totalResult,
        totalCredit: totalCredit,
        subjectList: List.of(state.subjects),
      );

      await _semesterRepository.addSemester(semester);
      _log.d(
        'SemesterConfirmed: saved "${semester.name}" with SGPA ${semester.sgpa}',
      );

      emit(state.copyWith(status: AddSemesterStatus.saved));
    } catch (e) {
      _log.e('SemesterConfirmed failed: $e');
      emit(state.copyWith(
        status: AddSemesterStatus.error,
        errorMessage: 'Failed to save semester. Please try again.',
      ));
    }
  }
}
