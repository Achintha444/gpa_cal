import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpa_cal/core/entities/semester.dart';
import 'package:gpa_cal/core/entities/subject.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/utils/gpa_calculator.dart';
import 'package:gpa_cal/core/utils/log.dart';
import 'package:gpa_cal/features/onboarding/domain/repositories/user_details_repository.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:gpa_cal/features/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:gpa_cal/features/semester/domain/repositories/semester_repository.dart';

/// Manages the onboarding flow state across the profile setup and first
/// semester screens.
///
/// Coordinates saving the user profile via [UserDetailsRepository] and
/// persisting the first semester via [SemesterRepository].
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  /// Logger for this BLoC.
  static final Log _log = Log('OnboardingBloc');

  /// Repository for persisting the user's profile details.
  final UserDetailsRepository _userDetailsRepository;

  /// Repository for persisting the first semester.
  final SemesterRepository _semesterRepository;

  /// Creates an [OnboardingBloc] with the given repositories.
  OnboardingBloc({
    required UserDetailsRepository userDetailsRepository,
    required SemesterRepository semesterRepository,
  })  : _userDetailsRepository = userDetailsRepository,
        _semesterRepository = semesterRepository,
        super(const OnboardingState()) {
    on<NameChanged>(_onNameChanged);
    on<UniversityChanged>(_onUniversityChanged);
    on<GpaTypeChanged>(_onGpaTypeChanged);
    on<ProfileSubmitted>(_onProfileSubmitted);
    on<FirstSemesterSubmitted>(_onFirstSemesterSubmitted);
  }

  /// Handles [NameChanged] — updates the name field in state.
  void _onNameChanged(
    NameChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
      status: OnboardingStatus.initial,
      errorMessage: '',
    ));
  }

  /// Handles [UniversityChanged] — updates the university field in state.
  void _onUniversityChanged(
    UniversityChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(
      university: event.university,
      status: OnboardingStatus.initial,
      errorMessage: '',
    ));
  }

  /// Handles [GpaTypeChanged] — updates the selected GPA scale in state.
  void _onGpaTypeChanged(
    GpaTypeChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(gpaType: event.gpaType));
  }

  /// Handles [ProfileSubmitted] — validates and persists the user's profile.
  ///
  /// Emits [OnboardingStatus.loading] during the save, then
  /// [OnboardingStatus.success] on success or [OnboardingStatus.error]
  /// on failure.
  Future<void> _onProfileSubmitted(
    ProfileSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    if (!state.isProfileValid) {
      emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: 'Please fill in your name and university.',
      ));
      return;
    }

    emit(state.copyWith(status: OnboardingStatus.loading));

    try {
      final UserDetails userDetails = UserDetails(
        name: state.name.trim(),
        university: state.university.trim(),
        gpaType: state.gpaType,
      );

      await _userDetailsRepository.saveUserDetails(userDetails);
      _log.d('ProfileSubmitted: saved details for "${userDetails.name}"');

      emit(state.copyWith(status: OnboardingStatus.success));
    } catch (e) {
      _log.e('ProfileSubmitted failed: $e');
      emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: 'Failed to save your profile. Please try again.',
      ));
    }
  }

  /// Handles [FirstSemesterSubmitted] — builds and persists the first semester.
  ///
  /// Calculates SGPA and total credit/result values in the domain layer via
  /// [GpaCalculator], then persists via [SemesterRepository]. Emits
  /// [OnboardingStatus.success] on completion.
  Future<void> _onFirstSemesterSubmitted(
    FirstSemesterSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));

    try {
      final List<Subject> validSubjects = event.subjects
          .where((Subject s) => s.credit > 0)
          .toList();

      final double sgpa = GpaCalculator.calculateSgpa(
        subjects: validSubjects,
        gpaType: state.gpaType,
      );

      double totalResult = 0.0;
      double totalCredit = 0.0;

      for (final Subject subject in validSubjects) {
        final double gradePoint =
            GpaCalculator.gradePointFor(subject.grade, state.gpaType);
        totalResult += gradePoint * subject.credit;
        totalCredit += subject.credit;
      }

      final Semester semester = Semester(
        hash: DateTime.now().millisecondsSinceEpoch,
        name: event.semesterName.trim().isEmpty
            ? 'Semester 1'
            : event.semesterName.trim(),
        sgpa: sgpa,
        totalResult: totalResult,
        totalCredit: totalCredit,
        subjectList: List.of(validSubjects),
      );

      await _semesterRepository.addSemester(semester);
      _log.d(
        'FirstSemesterSubmitted: saved "${semester.name}" with SGPA $sgpa',
      );

      emit(state.copyWith(status: OnboardingStatus.success));
    } catch (e) {
      _log.e('FirstSemesterSubmitted failed: $e');
      emit(state.copyWith(
        status: OnboardingStatus.error,
        errorMessage: 'Failed to save your semester. Please try again.',
      ));
    }
  }
}
