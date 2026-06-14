// GENERATED CODE - DO NOT MODIFY BY HAND
// Manually written type adapter — run build_runner to regenerate if model changes.

part of 'semester_model.dart';

/// Hive [TypeAdapter] for [SemesterModel].
///
/// Registered at app startup in `main.dart` before any Hive box is opened.
/// typeId: 0 — must match the `@HiveType(typeId: 0)` annotation on [SemesterModel].
class SemesterModelAdapter extends TypeAdapter<SemesterModel> {
  @override
  final int typeId = 0;

  @override
  SemesterModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SemesterModel()
      ..hash = fields[0] as int
      ..name = fields[1] as String
      ..sgpa = fields[2] as double
      ..totalResult = fields[3] as double
      ..totalCredit = fields[4] as double
      ..subjectList = (fields[5] as List).cast<SubjectModel>();
  }

  @override
  void write(BinaryWriter writer, SemesterModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.hash)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sgpa)
      ..writeByte(3)
      ..write(obj.totalResult)
      ..writeByte(4)
      ..write(obj.totalCredit)
      ..writeByte(5)
      ..write(obj.subjectList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemesterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
