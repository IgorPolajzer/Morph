import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

enum TaskType {
  PHYSICAL,
  GENERAL,
  MENTAL;

  Color getColor() {
    switch (this) {
      case TaskType.PHYSICAL:
        return kPhysicalColor;
      case TaskType.MENTAL:
        return kMentalColor;
      case TaskType.GENERAL:
        return kGeneralColor;
    }
  }
}
