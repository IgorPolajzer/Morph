import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';
import 'Experience.dart';
import 'habit.dart';

class User extends ChangeNotifier {
  late final DateTime createdAt;
  late final String id;

  Map<HabitType, bool> _selectedHabits = {};
  Map<HabitType, List<Habit>> _habits = {};
  Map<HabitType, List<Task>> _tasks = {};
  Map<HabitType, Experience> _xp = {};

  get getSelectedHabits {
    return {
      HabitType.PHYSICAL: _selectedHabits[HabitType.PHYSICAL] ?? false,
      HabitType.GENERAL: _selectedHabits[HabitType.GENERAL] ?? false,
      HabitType.MENTAL: _selectedHabits[HabitType.MENTAL] ?? false,
    };
  }

  List<Habit>? getHabitsFromType(HabitType type) {
    switch (type) {
      case HabitType.PHYSICAL:
        return _habits[HabitType.PHYSICAL];
      case HabitType.GENERAL:
        return _habits[HabitType.GENERAL];
      case HabitType.MENTAL:
        return _habits[HabitType.MENTAL];
    }
  }

  List<Task>? getTasksFromType(HabitType type) {
    switch (type) {
      case HabitType.PHYSICAL:
        return _tasks[HabitType.PHYSICAL];
      case HabitType.GENERAL:
        return _tasks[HabitType.GENERAL];
      case HabitType.MENTAL:
        return _tasks[HabitType.MENTAL];
    }
  }

  void setGoals(bool physical, bool general, bool mental) async {
    // Set selected habits
    _selectedHabits[HabitType.PHYSICAL] = physical;
    _selectedHabits[HabitType.GENERAL] = general;
    _selectedHabits[HabitType.MENTAL] = mental;

    // Set habit lists
    if (_selectedHabits[HabitType.PHYSICAL]! &&
        _habits[HabitType.PHYSICAL] == null)
      _habits[HabitType.PHYSICAL] = <Habit>[];
    if (_selectedHabits[HabitType.GENERAL]! &&
        _habits[HabitType.GENERAL] == null)
      _habits[HabitType.GENERAL] = <Habit>[];
    if (_selectedHabits[HabitType.MENTAL]! && _habits[HabitType.MENTAL] == null)
      _habits[HabitType.MENTAL] = <Habit>[];

    // Set task lists
    if (_selectedHabits[HabitType.PHYSICAL]! &&
        _tasks[HabitType.PHYSICAL] == null)
      _tasks[HabitType.PHYSICAL] = <Task>[];
    if (_selectedHabits[HabitType.GENERAL]! &&
        _tasks[HabitType.GENERAL] == null)
      _tasks[HabitType.GENERAL] = <Task>[];
    if (_selectedHabits[HabitType.MENTAL]! && _tasks[HabitType.MENTAL] == null)
      _tasks[HabitType.MENTAL] = <Task>[];

    // Set experience lists
    if (_selectedHabits[HabitType.PHYSICAL]! && _xp[HabitType.PHYSICAL] == null)
      _xp[HabitType.PHYSICAL] = Experience();
    if (_selectedHabits[HabitType.GENERAL]! && _xp[HabitType.GENERAL] == null)
      _xp[HabitType.GENERAL] = Experience();
    if (_selectedHabits[HabitType.MENTAL]! && _xp[HabitType.MENTAL] == null)
      _xp[HabitType.MENTAL] = Experience();
  }

  void pushUserToFirebase() async {
    // TODO call when user completes registration or changes any plans
  }

  void getUserFromFireBase() async {
    // Handle user id
    id = FirebaseAuth.instance.currentUser!.uid;
    if (id == null) return;

    // Handle selected habits
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final selectedHabits = doc.data()?['selectedHabits'];

    _selectedHabits[HabitType.PHYSICAL] = selectedHabits['physical'];
    _selectedHabits[HabitType.GENERAL] = selectedHabits['general'];
    _selectedHabits[HabitType.MENTAL] = selectedHabits['mental'];

    setGoals(
      _selectedHabits[HabitType.PHYSICAL]!,
      _selectedHabits[HabitType.GENERAL]!,
      _selectedHabits[HabitType.MENTAL]!,
    );

    // Get habits
    final habits = await Habit.getHabitsFromFirebase(id);

    for (Habit habit in habits) {
      switch (habit.type) {
        case HabitType.PHYSICAL:
          _habits[HabitType.PHYSICAL]?.add(habit);
        case HabitType.GENERAL:
          _habits[HabitType.GENERAL]?.add(habit);
        case HabitType.MENTAL:
          _habits[HabitType.MENTAL]?.add(habit);
      }
    }

    // Handle tasks
    final tasks = await Task.getTasksFromFirebase(id);

    for (Task task in tasks) {
      switch (task.type) {
        case HabitType.PHYSICAL:
          _tasks[HabitType.PHYSICAL]?.add(task);
        case HabitType.GENERAL:
          _tasks[HabitType.GENERAL]?.add(task);
        case HabitType.MENTAL:
          _tasks[HabitType.MENTAL]?.add(task);
      }
    }

    notifyListeners();
  }
}
