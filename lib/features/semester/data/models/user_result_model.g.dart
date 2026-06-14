// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written type adapter — run build_runner to regenerate if model changes.

part of 'user_result_model.dart';

/// Hive [TypeAdapter] for [UserResultModel].
///
/// Registered at app startup in `main.dart` before any Hive box is opened.
/// typeId: 3 — must match the `@HiveType(typeId: 3)` annotation on [UserResultModel].
class UserResultModelAdapter extends TypeAdapter<UserResultModel> {
  @override
  final int typeId = 3;

  @override
  UserResultModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserResultModel()
      ..cgpa = fields[0] as double
      ..cumulativeResult = fields[1] as double
      ..cumulativeCredit = fields[2] as double
      ..semesters = (fields[3] as List).cast<SemesterModel>();
  }

  @override
  void write(BinaryWriter writer, UserResultModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.cgpa)
      ..writeByte(1)
      ..write(obj.cumulativeResult)
      ..writeByte(2)
      ..write(obj.cumulativeCredit)
      ..writeByte(3)
      ..write(obj.semesters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
