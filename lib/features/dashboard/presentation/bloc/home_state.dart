import 'package:equatable/equatable.dart';
import 'package:gpa_cal/core/entities/user_details.dart';
import 'package:gpa_cal/core/entities/user_result.dart';

/// The loading status of the home screen.
enum HomeStatus {
  /// The initial state before any data has been requested.
  initial,

  /// Data is currently being fetched.
  loading,

  /// Data loaded successfully and at least one semester exists.
  success,

  /// Data loaded but no semesters have been added yet.
  empty,

  /// An error occurred during data loading.
  error,
}

/// The state for [HomeBloc].
///
/// Holds the loaded [UserResult] and [UserDetails] alongside the current
/// [HomeStatus] and any error message.
class HomeState extends Equatable {
  /// The current loading status.
  final HomeStatus status;

  /// The cumulative user result including all semesters. Null until loaded.
  final UserResult? userResult;

  /// The user's profile details. Null until loaded.
  final UserDetails? userDetails;

  /// The error message to display. Empty string when no error.
  final String errorMessage;

  /// Creates a [HomeState].
  const HomeState({
    this.status = HomeStatus.initial,
    this.userResult,
    this.userDetails,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props => [status, userResult, userDetails, errorMessage];

  /// Creates a copy of this state with the given fields replaced.
  HomeState copyWith({
    HomeStatus? status,
    UserResult? userResult,
    UserDetails? userDetails,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      userResult: userResult ?? this.userResult,
      userDetails: userDetails ?? this.userDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
