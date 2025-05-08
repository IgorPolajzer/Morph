import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';

class TaskData extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      startDateTime: DateTime(2025, 5, 5, 19, 0),
      endDateTime: DateTime(2025, 5, 5, 21, 0),
      title: "Upper body workout",
      subtitle: "Workout for the upper body",
      description: "Workout for the upper body",
      type: HabitType.PHYSICAL,
    ),
    Task(
      startDateTime: DateTime(2025, 5, 6, 19, 0),
      endDateTime: DateTime(2025, 5, 6, 20, 0),
      title: "Lower body workout",
      subtitle: "Workout for the lower body",
      description: "Workout for the lower body",
      type: HabitType.PHYSICAL,
    ),
    Task(
      startDateTime: DateTime(2025, 5, 7, 19, 0),
      endDateTime: DateTime(2025, 5, 7, 21, 0),
      title: "Swimming",
      subtitle: "Interval crawl swimming",
      description: "Interval crawl swimming",
      type: HabitType.PHYSICAL,
    ),
    Task(
      startDateTime: DateTime(2025, 5, 8, 19, 0),
      endDateTime: DateTime(2025, 5, 8, 21, 0),
      title: "Upper body workout",
      subtitle: "Workout for the upper body",
      description: "Workout for the upper body",
      type: HabitType.PHYSICAL,
    ),
    Task(
      startDateTime: DateTime(2025, 5, 9, 19, 0),
      endDateTime: DateTime(2025, 5, 9, 21, 0),
      title: "Lower body workout",
      subtitle: "Workout for the lower body",
      description: "Workout for the lower body",
      type: HabitType.PHYSICAL,
    ),
  ];

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  int get taskCount => tasks.length;

  void addPhysicalTask(
    DateTime startDateTime,
    DateTime endDateTime,
    String title,
    String subtitle,
    String description,
    HabitType type,
  ) {
    _tasks.add(
      Task(
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        title: title,
        subtitle: subtitle,
        description: description,
        type: type,
      ),
    );
    notifyListeners();
  }

  void updatePhysicalTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void deletePhysicalTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}
