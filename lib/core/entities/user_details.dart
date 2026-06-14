import 'package:equatable/equatable.dart';

/// Holds the user's personal profile and grading scale preference.
///
/// Persisted at onboarding and referenced throughout the app for
/// personalisation and GPA scale selection.
class UserDetails extends Equatable {
  /// The user's display name.
  final String name;

  /// The user's university or institution name.
  final String university;

  /// The grading scale preference.
  ///
  /// `0` = 4.0 scale (standard), `1` = 4.2 scale (extended A+).
  final int gpaType;

  /// Creates a [UserDetails] instance with the given profile data.
  const UserDetails({
    required this.name,
    required this.university,
    required this.gpaType,
  });

  @override
  List<Object?> get props => [name, university, gpaType];

  /// Creates a copy of this [UserDetails] with the given fields replaced.
  UserDetails copyWith({
    String? name,
    String? university,
    int? gpaType,
  }) {
    return UserDetails(
      name: name ?? this.name,
      university: university ?? this.university,
      gpaType: gpaType ?? this.gpaType,
    );
  }
}
