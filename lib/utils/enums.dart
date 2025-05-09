import 'package:flutter/material.dart';
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
}

enum Days { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

enum Frequency { DAILY, WEEKLY, BYWEEKLY, MONTHLY }
