import 'package:hive/hive.dart';
import 'package:gpa_cal/core/entities/user_details.dart';

part 'user_details_model.g.dart';

/// Hive-persisted model for the user's profile and GPA scale preference.
///
/// Maps to and from the domain [UserDetails] entity in the repository layer.
/// A single instance is stored in the Hive box — representing the currently
/// registered user. This model is used exclusively within the data layer.
@HiveType(typeId: 2)
class UserDetailsModel extends HiveObject {
  /// Creates an empty [UserDetailsModel].
  ///
  /// Fields are populated via Hive deserialization or [fromDomain].
  UserDetailsModel();
  /// The user's display name.
  @HiveField(0)
  late String name;

  /// The user's university or institution name.
  @HiveField(1)
  late String university;

  /// The grading scale preference: `0` = 4.0 scale, `1` = 4.2 scale.
  @HiveField(2)
  late int gpaType;

  /// Converts this Hive model to a domain [UserDetails] entity.
  UserDetails toDomain() {
    return UserDetails(
      name: name,
      university: university,
      gpaType: gpaType,
    );
  }

  /// Creates a [UserDetailsModel] from a domain [UserDetails] entity.
  factory UserDetailsModel.fromDomain(UserDetails userDetails) {
    return UserDetailsModel()
      ..name = userDetails.name
      ..university = userDetails.university
      ..gpaType = userDetails.gpaType;
  }
}
