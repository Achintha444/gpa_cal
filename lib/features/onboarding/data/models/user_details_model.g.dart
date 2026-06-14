// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written type adapter — run build_runner to regenerate if model changes.

part of 'user_details_model.dart';

/// Hive [TypeAdapter] for [UserDetailsModel].
///
/// Registered at app startup in `main.dart` before any Hive box is opened.
/// typeId: 2 — must match the `@HiveType(typeId: 2)` annotation on [UserDetailsModel].
class UserDetailsModelAdapter extends TypeAdapter<UserDetailsModel> {
  @override
  final int typeId = 2;

  @override
  UserDetailsModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDetailsModel()
      ..name = fields[0] as String
      ..university = fields[1] as String
      ..gpaType = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, UserDetailsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.university)
      ..writeByte(2)
      ..write(obj.gpaType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
