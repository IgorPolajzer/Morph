import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';
import '../utils/functions.dart';
import 'experience.dart';
import 'habit.dart';

class UserData extends ChangeNotifier {
  bool loading = false;
  late final String id;

  late String _email;
  String get email => _email;

  late String _password;
  String get password => _password;

  late String _username;
  String get username => _username;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Map<HabitType, bool> _selectedHabits = {};
  Map<HabitType, List<Habit>> _habits = {};
  Map<HabitType, List<Task>> _tasks = {};
  Map<HabitType, Experience> _xp = {};

  // User auth operations
  void setCredentials(String email, String username, String password) {
    _email = email;
    _username = username;
    _password = password;
  }

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
  void deleteHabit(Habit habit) {
    final habits = _habits[habit.type];
    if (habits == null) return;

    habits.removeWhere((habitEntry) => habit.id == habitEntry.id);
    notifyListeners();
  }

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

  // Task operations
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

  List<Task> getTasks(DateTime currentDateTime) {
    final List<Task> allTasks = [];

    for (final type in HabitType.values) {
      final tasksOfType = _tasks[type] ?? [];

      for (final task in tasksOfType) {
        final taskStartDateTime = task.scheduledDay.toDateTime(
          date: task.startDateTime,
        );

        final taskStartDate = stripTime(taskStartDateTime);
        final currentDate = stripTime(currentDateTime);

        final isSameWeekday =
            currentDateTime.weekday == task.scheduledDay.index + 1;
        final isBeforeOrToday =
            task.startDateTime.isBefore(currentDate) ||
            task.startDateTime.day == currentDate.day;

        switch (task.scheduledFrequency) {
          case Frequency.DAILY:
            if (isBeforeOrToday) allTasks.add(task);
            break;
          case Frequency.WEEKLY:
            if (isBeforeOrToday && isSameWeekday) allTasks.add(task);
            break;
          case Frequency.BYWEEKLY:
            final diff = currentDate.difference(taskStartDate).inDays;

            if (isBeforeOrToday && isSameWeekday) {
              if (diff >= 0 && diff % 14 == 0) {
                allTasks.add(task);
              }
            }
            break;
          case Frequency.MONTHLY:
            if (currentDateTime.day == taskStartDateTime.day &&
                isBeforeOrToday) {
              allTasks.add(task);
            }
            break;
        }
      }
    }

    return allTasks;
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

  //Firebase interactions
  void pullFromFireBase() async {
    if (_isInitialized) return;

    loading = true;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      loading = false;
      return;
    }
    id = currentUser.uid;

    // Get user document
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final data = docSnapshot.data();
    if (data == null) {
      loading = false;
      return;
    }
    // Get username and email
    _username = data['username'] ?? '';
    _email = data['email'] ?? '';

    // Get selected habits
    final selectedHabits = data['selectedHabits'] ?? {};
    _selectedHabits[HabitType.PHYSICAL] = selectedHabits['physical'] ?? false;
    _selectedHabits[HabitType.GENERAL] = selectedHabits['general'] ?? false;
    _selectedHabits[HabitType.MENTAL] = selectedHabits['mental'] ?? false;

    setGoals(
      _selectedHabits[HabitType.PHYSICAL]!,
      _selectedHabits[HabitType.GENERAL]!,
      _selectedHabits[HabitType.MENTAL]!,
    );

    // Get habits
    final habits = await Habit.pullFromFirebase(id);
    for (Habit habit in habits) {
      _habits[habit.type]?.add(habit);
    }

    // Get tasks
    final tasks = await Task.pullFromFirebase(id);
    for (Task task in tasks) {
      _tasks[task.type]?.add(task);
    }

    _isInitialized = true;
    loading = false;
    notifyListeners();
  }

  void pushToFirebase() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not authenticated");
      final userId = currentUser.uid;
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);

      // Store username and email
      await userDoc.set({
        'username': username,
        'email': email,
      }, SetOptions(merge: true));

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
