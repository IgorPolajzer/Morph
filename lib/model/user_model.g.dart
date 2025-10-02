// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel()
      ..email = fields[0] as String
      ..username = fields[1] as String
      ..completedTasks = (fields[2] as List).cast<String>()
      ..experience = (fields[3] as Map).cast<HabitType, Experience>()
      ..selectedHabits = (fields[4] as Map).cast<HabitType, bool>()
      ..dirty = fields[5] as bool
      ..deleted = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.completedTasks)
      ..writeByte(3)
      ..write(obj.experience)
      ..writeByte(4)
      ..write(obj.selectedHabits)
      ..writeByte(5)
      ..write(obj.dirty)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
