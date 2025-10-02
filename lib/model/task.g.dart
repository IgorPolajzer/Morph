// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String?,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      description: fields[3] as String,
      scheduledFrequency: fields[4] as Frequency,
      scheduledDay: fields[5] as Day,
      startDateTime: fields[6] as DateTime,
      endDateTime: fields[7] as DateTime,
      type: fields[8] as HabitType,
      notifications: fields[9] as bool,
    )
      ..dirty = fields[10] as bool
      ..deleted = fields[11] as bool;
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.scheduledFrequency)
      ..writeByte(5)
      ..write(obj.scheduledDay)
      ..writeByte(6)
      ..write(obj.startDateTime)
      ..writeByte(7)
      ..write(obj.endDateTime)
      ..writeByte(8)
      ..write(obj.type)
      ..writeByte(9)
      ..write(obj.notifications)
      ..writeByte(10)
      ..write(obj.dirty)
      ..writeByte(11)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
