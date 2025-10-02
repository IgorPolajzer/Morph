import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';
import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 4)
enum HabitType {
  @HiveField(0)
  PHYSICAL,

  @HiveField(1)
  GENERAL,

  @HiveField(2)
  MENTAL;

  Color getColor() {
    switch (this) {
      case HabitType.PHYSICAL:
        return kPhysicalColor;
      case HabitType.MENTAL:
        return kMentalColor;
      case HabitType.GENERAL:
        return kGeneralColor;
    }
  }

  static HabitType getTypeFromString(String type) {
    switch (type) {
      case "physical":
        return HabitType.PHYSICAL;
      case "mental":
        return HabitType.MENTAL;
      case "general":
        return HabitType.GENERAL;
      default:
        throw Exception('Invalid habit type provided');
    }
  }

  String format() {
    return name[0] + name.substring(1).toLowerCase();
  }
}

@HiveType(typeId: 5)
enum Day {
  @HiveField(0)
  MONDAY,
  @HiveField(1)
  TUESDAY,
  @HiveField(2)
  WEDNESDAY,
  @HiveField(3)
  THURSDAY,
  @HiveField(4)
  FRIDAY,
  @HiveField(5)
  SATURDAY,
  @HiveField(6)
  SUNDAY;

  static Day getDayFromString(String type) {
    switch (type) {
      case "monday":
        return Day.MONDAY;
      case "tuesday":
        return Day.TUESDAY;
      case "wednesday":
        return Day.WEDNESDAY;
      case "thursday":
        return Day.THURSDAY;
      case "friday":
        return Day.FRIDAY;
      case "saturday":
        return Day.SATURDAY;
      case "sunday":
        return Day.SUNDAY;
      case "":
        final weekday =
            [
              'monday',
              'tuesday',
              'wednesday',
              'thursday',
              'friday',
              'saturday',
              'sunday',
            ][DateTime.now().weekday - 1];
        return getDayFromString(weekday);
      default:
        throw Exception('Invalid day type provided');
    }
  }

  DateTime toDateTime({DateTime? date}) {
    final fromDate = date ?? DateTime.now();
    final todayWeekday = fromDate.weekday; // 1 (Mon) - 7 (Sun)
    final targetWeekday = index + 1;

    int daysDifference = (targetWeekday - todayWeekday) % 7;
    if (daysDifference < 0) daysDifference += 7;

    return fromDate.add(Duration(days: daysDifference));
  }

  String format() {
    return name[0] + name.substring(1).toLowerCase();
  }
}

@HiveType(typeId: 6)
enum Frequency {
  @HiveField(0)
  DAILY,
  @HiveField(1)
  WEEKLY,
  @HiveField(2)
  BYWEEKLY,
  @HiveField(3)
  MONTHLY;

  static Frequency getFrequencyFromString(String type) {
    switch (type) {
      case "daily":
        return Frequency.DAILY;
      case "weekly":
        return Frequency.WEEKLY;
      case "byweekly":
        return Frequency.BYWEEKLY;
      case "monthly":
        return Frequency.MONTHLY;
      default:
        throw Exception('Invalid frequency type provided');
    }
  }

  String format() {
    return name[0] + name.substring(1).toLowerCase();
  }
}

@HiveType(typeId: 6)
enum AppLoadState {
  @HiveField(0)
  notInitialized,
  @HiveField(1)
  loading,
  @HiveField(2)
  ready,
  @HiveField(3)
  error,
}
