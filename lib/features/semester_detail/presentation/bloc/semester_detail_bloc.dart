import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/user_result.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';
import 'package:gpa_cal/features/semester_detail/presentation/bloc/semester_detail_event.dart';
import 'package:gpa_cal/features/semester_detail/presentation/bloc/semester_detail_state.dart';

/// Manages the state for the semester detail screen.
///
/// Loads the full [UserResult] from [SemesterRepository] and finds the
/// [Semester] matching the requested hash. Emits an error state if the
/// semester cannot be found.
class SemesterDetailBloc
    extends Bloc<SemesterDetailEvent, SemesterDetailState> {
  /// Logger for this BLoC.
  static final Log _log = Log('SemesterDetailBloc');

  /// Repository for reading semester data.
  final SemesterRepository _semesterRepository;

  /// Creates a [SemesterDetailBloc] with the given [semesterRepository].
  SemesterDetailBloc({required SemesterRepository semesterRepository})
      : _semesterRepository = semesterRepository,
        super(const SemesterDetailState()) {
    on<SemesterDetailRequested>(_onSemesterDetailRequested);
  }

  /// Handles [SemesterDetailRequested] — loads the semester by [event.hash].
  ///
  /// Emits [SemesterDetailStatus.loading] while loading, then
  /// [SemesterDetailStatus.success] with the found semester or
  /// [SemesterDetailStatus.error] if the semester is not found or an
  /// exception occurs.
  Future<void> _onSemesterDetailRequested(
    SemesterDetailRequested event,
    Emitter<SemesterDetailState> emit,
  ) async {
    emit(state.copyWith(status: SemesterDetailStatus.loading));

    try {
      final UserResult userResult = await _semesterRepository.getUserResult();

      final Semester? semester = userResult.semesters.where(
        (Semester s) => s.hash == event.hash,
      ).firstOrNull;

      if (semester == null) {
        _log.e(
          'SemesterDetailRequested: no semester found for hash=${event.hash}',
        );
        emit(state.copyWith(
          status: SemesterDetailStatus.error,
          errorMessage: 'Semester not found.',
        ));
        return;
      }

      _log.d(
        'SemesterDetailRequested: loaded "${semester.name}" '
        'with SGPA ${semester.sgpa}',
      );

      emit(state.copyWith(
        status: SemesterDetailStatus.success,
        semester: semester,
        errorMessage: '',
      ));
    } catch (e) {
      _log.e('SemesterDetailRequested failed: $e');
      emit(state.copyWith(
        status: SemesterDetailStatus.error,
        errorMessage: 'Failed to load semester. Please try again.',
      ));
    }
  }
}
