import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';
import 'experience.dart';
import 'habit.dart';

class User extends ChangeNotifier {
  bool loading = false;
  late final String id;

  Map<HabitType, bool> _selectedHabits = {};
  Map<HabitType, List<Habit>> _habits = {};
  Map<HabitType, List<Task>> _tasks = {};
  Map<HabitType, Experience> _xp = {};

  // Selected goals operations
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

  // Habit operations
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

  void deleteHabit(Habit habit) {
    final habits = _habits[habit.type];
    if (habits == null) return;

    habits.removeWhere((habitEntry) => habit.id == habitEntry.id);
    notifyListeners();
  }

  // Task operations
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

  void addTask(Task task) {
    switch (task.type) {
      case HabitType.PHYSICAL:
        _tasks[HabitType.PHYSICAL]?.add(task);
      case HabitType.GENERAL:
        _tasks[HabitType.GENERAL]?.add(task);
      case HabitType.MENTAL:
        _tasks[HabitType.MENTAL]?.add(task);
    }

    notifyListeners();
  }

  void deleteTask(Task newTask) {
    final tasks = _tasks[newTask.type];
    if (tasks == null) return;

    tasks.removeWhere((taskEntry) => newTask.id == taskEntry.id);
    notifyListeners();
  }

  void updateTask(
    String title,
    String subtitle,
    String description,
    Frequency frequency,
    Day day,
    DateTime startDateTime,
    DateTime endDateTime,
    bool notifications,
    HabitType type,
    String taskId,
  ) {
    final tasks = _tasks[type];
    if (tasks == null) return;

    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      Task task = tasks[index];
      task.title = title;
      task.subtitle = subtitle;
      task.description = description;
      task.scheduledFrequency = frequency;
      task.scheduledDay = day;
      task.startDateTime = startDateTime;
      task.endDateTime = endDateTime;
      task.notifications = notifications;
    }

    notifyListeners();
  }

  //Firebase interactions
  void getFromFireBase() async {
    loading = true;
    notifyListeners();

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

    loading = false;
    notifyListeners();
  }

  void updateFirebase() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not authenticated");
      final userId = currentUser.uid;
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      // Store selected habits
      await userDoc.set({
        'selectedHabits': {
          'physical': _selectedHabits[HabitType.PHYSICAL] ?? false,
          'general': _selectedHabits[HabitType.GENERAL] ?? false,
          'mental': _selectedHabits[HabitType.MENTAL] ?? false,
        },
      }, SetOptions(merge: true));

      // Clear and re-upload habits
      final habitsRef = userDoc.collection('habits');
      final habitDocs = await habitsRef.get();
      for (var doc in habitDocs.docs) {
        await doc.reference.delete();
      }

      for (HabitType type in HabitType.values) {
        final habits = _habits[type] ?? [];
        for (final habit in habits) {
          await habitsRef.doc(habit.id).set(habit.toMap());
        }
      }

      // Clear and re-upload tasks
      final tasksRef = userDoc.collection('tasks');
      final taskDocs = await tasksRef.get();
      for (var doc in taskDocs.docs) {
        await doc.reference.delete();
      }

      for (HabitType type in HabitType.values) {
        final tasks = _tasks[type] ?? [];
        for (final task in tasks) {
          await tasksRef.doc(task.id).set(task.toMap());
        }
      }
    } catch (e) {
      print(e);
      throw Exception("Error pushing user data to Firebase: $e");
    }
  }
}
