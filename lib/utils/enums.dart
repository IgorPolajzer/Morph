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
      case "PHYSICAL":
        return HabitType.PHYSICAL;
      case "MENTAL":
        return HabitType.MENTAL;
      case "GENERAL":
        return HabitType.GENERAL;
      default:
        throw Exception('Invalid habit type provided');
    }
  }
}
