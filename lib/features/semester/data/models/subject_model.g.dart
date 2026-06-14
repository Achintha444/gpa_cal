// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written type adapter — run build_runner to regenerate if model changes.

part of 'subject_model.dart';

/// Hive [TypeAdapter] for [SubjectModel].
///
/// Registered at app startup in `main.dart` before any Hive box is opened.
/// typeId: 1 — must match the `@HiveType(typeId: 1)` annotation on [SubjectModel].
class SubjectModelAdapter extends TypeAdapter<SubjectModel> {
  @override
  final int typeId = 1;

  @override
  SubjectModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectModel()
      ..courseName = fields[0] as String
      ..grade = fields[1] as String
      ..credit = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, SubjectModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.courseName)
      ..writeByte(1)
      ..write(obj.grade)
      ..writeByte(2)
      ..write(obj.credit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
