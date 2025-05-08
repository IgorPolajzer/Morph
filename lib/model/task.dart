import 'package:flutter/cupertino.dart';
import '../utils/enums.dart';

class Task {
  String title;
  String subtitle;
  String description;
  DateTime startDateTime;
  DateTime endDateTime;
  HabitType type;
  late Widget customWidget;

  bool isDone;

  Task({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }
}
