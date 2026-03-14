import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:morphe/utils/constants.dart';

enum HabitType {
  PHYSICAL,

  GENERAL,

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

enum DayType {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY;

  /// Converts DayType enum to flutter_local_notifications Day enum
  Day dayTypeToDay() {
    switch (this) {
      case DayType.MONDAY:
        return Day.monday;
      case DayType.TUESDAY:
        return Day.tuesday;
      case DayType.WEDNESDAY:
        return Day.wednesday;
      case DayType.THURSDAY:
        return Day.thursday;
      case DayType.FRIDAY:
        return Day.friday;
      case DayType.SATURDAY:
        return Day.saturday;
      case DayType.SUNDAY:
        return Day.sunday;
    }
  }

  static DayType getDayFromString(String type) {
    switch (type) {
      case "monday":
        return DayType.MONDAY;
      case "tuesday":
        return DayType.TUESDAY;
      case "wednesday":
        return DayType.WEDNESDAY;
      case "thursday":
        return DayType.THURSDAY;
      case "friday":
        return DayType.FRIDAY;
      case "saturday":
        return DayType.SATURDAY;
      case "sunday":
        return DayType.SUNDAY;
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

enum Frequency {
  DAILY,
  WEEKLY,
  MONTHLY;

  static Frequency getFrequencyFromString(String type) {
    switch (type) {
      case "daily":
        return Frequency.DAILY;
      case "weekly":
        return Frequency.WEEKLY;
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

enum AppLoadState { notInitialized, loading, ready, error }
