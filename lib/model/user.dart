import 'package:flutter/cupertino.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';
import 'Experience.dart';
import 'habit.dart';

class User extends ChangeNotifier {
  // Chosen habits
  Map<HabitType, bool> _chosenHabits = {};

  get getHabits {
    return {
      HabitType.PHYSICAL: _chosenHabits[HabitType.PHYSICAL] ?? false,
      HabitType.GENERAL: _chosenHabits[HabitType.GENERAL] ?? false,
      HabitType.MENTAL: _chosenHabits[HabitType.MENTAL] ?? false,
    };
  }

  // HabitData
  Map<HabitType, List<Habit>> _habits = {};

  // TaskData
  Map<HabitType, List<Task>> _tasks = {};

  // ExperienceData
  Map<HabitType, Experience> _xp = {};

  void setGoals(bool physical, bool general, bool mental) {
    _chosenHabits[HabitType.PHYSICAL] = physical;
    _chosenHabits[HabitType.GENERAL] = general;
    _chosenHabits[HabitType.MENTAL] = mental;

    // Set habit lists
    if (physical) _habits[HabitType.PHYSICAL] = <Habit>[];
    if (general) _habits[HabitType.GENERAL] = <Habit>[];
    if (mental) _habits[HabitType.MENTAL] = <Habit>[];

    // Set task lists
    if (physical) _tasks[HabitType.PHYSICAL] = <Task>[];
    if (general) _tasks[HabitType.GENERAL] = <Task>[];
    if (mental) _tasks[HabitType.MENTAL] = <Task>[];

    // Set experience lists
    if (physical) _xp[HabitType.PHYSICAL] = Experience();
    if (general) _xp[HabitType.GENERAL] = Experience();
    if (mental) _xp[HabitType.MENTAL] = Experience();

    notifyListeners();
  }
}
