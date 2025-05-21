import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphe/model/executable_task.dart';
import 'package:morphe/model/task.dart';

import '../utils/enums.dart';
import '../utils/functions.dart';
import 'experience.dart';
import 'habit.dart';

class UserData extends ChangeNotifier {
  static int TASK_RANGE = 7; // can complete tasks up to a maximum of 7 days old

  bool loading = false;
  bool _isInitialized = false;
  bool _executableTasksLoaded = false;

  late final String id;

  String? _email;
  String? _password;
  String? _username;
  int _metaLevel = 1;

  Map<HabitType, bool> _selectedHabits = {};
  Map<HabitType, Experience> _experience = {};
  Map<HabitType, List<Habit>> _habits = {};
  Map<HabitType, List<Task>> _tasks = {};

  // Tasks which can be completed today
  List<ExecutableTask> _executableTasks = <ExecutableTask>[];

  // Constructors
  UserData() {
    for (HabitType type in HabitType.values) {
      _habits[type] = <Habit>[];
      _tasks[type] = <Task>[];
      _experience[type] = Experience();
    }
  }

  // Getters and setters
  String get email => _email ?? "";
  String get password => _password ?? "";
  String get username => _username ?? "";
  bool get isInitialized => _isInitialized;
  bool get executableTasksLoaded => _executableTasksLoaded;
  int get metaLevel => _metaLevel;

  get selectedHabits {
    return {
      HabitType.PHYSICAL: _selectedHabits[HabitType.PHYSICAL] ?? false,
      HabitType.GENERAL: _selectedHabits[HabitType.GENERAL] ?? false,
      HabitType.MENTAL: _selectedHabits[HabitType.MENTAL] ?? false,
    };
  }

  get experience {
    return {
      HabitType.PHYSICAL: _experience[HabitType.PHYSICAL] ?? Experience(),
      HabitType.GENERAL: _experience[HabitType.GENERAL] ?? Experience(),
      HabitType.MENTAL: _experience[HabitType.MENTAL] ?? Experience(),
    };
  }

  void setCredentials(String email, String username, String password) {
    _email = email;
    _username = username;
    _password = password;
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

  get executableTasks => _executableTasks;

  // Gets all executable tasks scheduled on provided date
  List<ExecutableTask> getExecutableTasks(DateTime day) {
    var tasks = <ExecutableTask>[];

    for (ExecutableTask task in _executableTasks) {
      if (isSameDay(task.scheduledDateTime, day)) {
        tasks.add(task);
      }
    }

    return tasks;
  }

  // Sets executable tasks that can be completed in provided day
  Future<void> setExecutableTasks(DateTime today) async {
    var from = today.subtract(
      Duration(days: TASK_RANGE),
    ); // Tasks can be completed for TASK_RANGE number of days behind schedule

    // Executable tasks are tasks which are scheduled for TASK_RANGE number of days behind
    while (today.difference(from).inDays >= 0) {
      List<Task> tasks = getTasks(from);

      for (Task task in tasks) {
        final scheduledDateTime = DateTime(from.year, from.month, from.day);

        ExecutableTask executableTask = ExecutableTask(
          task: task,
          scheduledDateTime: scheduledDateTime,
          notifications: task.notifications,
        );

        // Check if task is in completedTasks
        DocumentSnapshot doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(getUserFirebaseId())
                .get();

        List<dynamic> completedTasks = doc['completedTasks'] ?? [];

        if (completedTasks.contains(
          getCompletedTaskId(task, scheduledDateTime),
        )) {
          executableTask.setIsDone = true;
        }

        _executableTasks.add(executableTask);
      }

      from = from.add(Duration(days: 1));
    }

    _executableTasksLoaded = true;
    notifyListeners();
  }

  // Gets all tasks scheduled on provided date
  List<Task> getTasks(DateTime currentDateTime) {
    final List<Task> allTasks = [];

    for (final type in HabitType.values) {
      final tasksOfType = _tasks[type] ?? [];

      if (_selectedHabits[type] ?? false) {
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

  void setSelectedHabits(bool physical, bool general, bool mental) {
    // Set selected habits
    _selectedHabits[HabitType.PHYSICAL] = physical;
    _selectedHabits[HabitType.GENERAL] = general;
    _selectedHabits[HabitType.MENTAL] = mental;
  }

  // Experience operations
  void incrementExperience(HabitType type) {
    _experience[type]?.increment();
    _experience[type]?.pushToFirebase();
    notifyListeners();
  }

  // Habit operations
  void deleteHabit(Habit habit) {
    final habits = _habits[habit.type];
    if (habits == null) return;

    habits.removeWhere((habitEntry) => habit.id == habitEntry.id);
    notifyListeners();
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

  //Firebase interactions
  void pullFromFireBase() async {
    if (_isInitialized) return;

    loading = true;
    notifyListeners();

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      loading = false;
      notifyListeners();
      return;
    }
    id = currentUser.uid;

    // Get user document
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    final data = docSnapshot.data();
    if (data == null) {
      loading = false;
      notifyListeners();
      return;
    }
    // Get username and email
    _username = data['username'] ?? '';
    _email = data['email'] ?? '';
    _metaLevel = data['metaLevel'] ?? 1;

    // Get selected habits
    final selectedHabits = data['selectedHabits'] ?? {};
    _selectedHabits[HabitType.PHYSICAL] = selectedHabits['physical'] ?? false;
    _selectedHabits[HabitType.GENERAL] = selectedHabits['general'] ?? false;
    _selectedHabits[HabitType.MENTAL] = selectedHabits['mental'] ?? false;

    setSelectedHabits(
      _selectedHabits[HabitType.PHYSICAL]!,
      _selectedHabits[HabitType.GENERAL]!,
      _selectedHabits[HabitType.MENTAL]!,
    );

    // Get experience
    final experience = data['experience'] ?? {};
    _experience[HabitType.PHYSICAL] = Experience.fromJson(
      experience['physical'],
    );
    _experience[HabitType.GENERAL] = Experience.fromJson(experience['general']);
    _experience[HabitType.MENTAL] = Experience.fromJson(experience['mental']);

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

    // Set tasks that are available for execution
    setExecutableTasks(DateTime.now());

    _isInitialized = true;
    loading = false;
    notifyListeners();
  }

  void pushToFirebase() async {
    try {
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(getUserFirebaseId());

      // Store username, email and metaLevel
      await userDoc.set({
        'username': username,
        'email': email,
        'metaLevel': _metaLevel,
      }, SetOptions(merge: true));

      // Store completedTasks
      await userDoc.set({'completedTasks': []});

      // Store experience
      await userDoc.set({
        'experience': {
          'physical': _experience[HabitType.PHYSICAL]?.toMap(),
          'general': _experience[HabitType.GENERAL]?.toMap(),
          'mental': _experience[HabitType.MENTAL]?.toMap(),
        },
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
