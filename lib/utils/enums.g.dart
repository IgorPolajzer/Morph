// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitTypeAdapter extends TypeAdapter<HabitType> {
  @override
  final int typeId = 4;

  @override
  HabitType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitType.PHYSICAL;
      case 1:
        return HabitType.GENERAL;
      case 2:
        return HabitType.MENTAL;
      default:
        return HabitType.PHYSICAL;
    }
  }

  @override
  void write(BinaryWriter writer, HabitType obj) {
    switch (obj) {
      case HabitType.PHYSICAL:
        writer.writeByte(0);
        break;
      case HabitType.GENERAL:
        writer.writeByte(1);
        break;
      case HabitType.MENTAL:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DayAdapter extends TypeAdapter<Day> {
  @override
  final int typeId = 5;

  @override
  Day read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Day.MONDAY;
      case 1:
        return Day.TUESDAY;
      case 2:
        return Day.WEDNESDAY;
      case 3:
        return Day.THURSDAY;
      case 4:
        return Day.FRIDAY;
      case 5:
        return Day.SATURDAY;
      case 6:
        return Day.SUNDAY;
      default:
        return Day.MONDAY;
    }
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    switch (obj) {
      case Day.MONDAY:
        writer.writeByte(0);
        break;
      case Day.TUESDAY:
        writer.writeByte(1);
        break;
      case Day.WEDNESDAY:
        writer.writeByte(2);
        break;
      case Day.THURSDAY:
        writer.writeByte(3);
        break;
      case Day.FRIDAY:
        writer.writeByte(4);
        break;
      case Day.SATURDAY:
        writer.writeByte(5);
        break;
      case Day.SUNDAY:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequencyAdapter extends TypeAdapter<Frequency> {
  @override
  final int typeId = 6;

  @override
  Frequency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Frequency.DAILY;
      case 1:
        return Frequency.WEEKLY;
      case 2:
        return Frequency.BYWEEKLY;
      case 3:
        return Frequency.MONTHLY;
      default:
        return Frequency.DAILY;
    }
  }

  @override
  void write(BinaryWriter writer, Frequency obj) {
    switch (obj) {
      case Frequency.DAILY:
        writer.writeByte(0);
        break;
      case Frequency.WEEKLY:
        writer.writeByte(1);
        break;
      case Frequency.BYWEEKLY:
        writer.writeByte(2);
        break;
      case Frequency.MONTHLY:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppLoadStateAdapter extends TypeAdapter<AppLoadState> {
  @override
  final int typeId = 6;

  @override
  AppLoadState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppLoadState.notInitialized;
      case 1:
        return AppLoadState.loading;
      case 2:
        return AppLoadState.ready;
      case 3:
        return AppLoadState.error;
      default:
        return AppLoadState.notInitialized;
    }
  }

  @override
  void write(BinaryWriter writer, AppLoadState obj) {
    switch (obj) {
      case AppLoadState.notInitialized:
        writer.writeByte(0);
        break;
      case AppLoadState.loading:
        writer.writeByte(1);
        break;
      case AppLoadState.ready:
        writer.writeByte(2);
        break;
      case AppLoadState.error:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppLoadStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
