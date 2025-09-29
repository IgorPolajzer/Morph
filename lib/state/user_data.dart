import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:morphe/model/executable_task.dart';
import 'package:morphe/model/task.dart';
import 'package:morphe/model/user.dart';
import 'package:morphe/repositories/impl/user_repository.dart';
import 'package:morphe/repositories/impl/task_repository.dart';
import 'package:morphe/repositories/impl/habit_repository.dart';

import '../model/experience.dart';
import '../model/habit.dart';
import '../utils/enums.dart';
import '../utils/functions.dart';

class UserData extends ChangeNotifier {
  static final int TASK_RANGE =
      7; // can complete tasks up to a maximum of 7 days old

  // Repositories
  final UserRepository userRepository = UserRepository();
  final TaskRepository taskRepository = TaskRepository();
  final HabitRepository habitRepository = HabitRepository();

  late UserModel _user;
  String? _userId;

  UserModel get user => _user;
  set user(UserModel? userModel) => _user = userModel!;
  String get userId => _userId ?? "";

  bool _loading = false;
  bool _isInitialized = false;
  bool _executableTasksLoaded = false;

  bool get isInitialized => _isInitialized;
  bool get loading => _loading;
  bool get executableTasksLoaded => _executableTasksLoaded;

  String? _password; //Don't store to Firestore.
  String get password => _password ?? "";

  int _metaLevel = 1;
  int _metaXp = 0;

  int get metaLevel => _metaLevel;
  int get metaXp => _metaXp;

  Map<HabitType, List<Habit>> _habits = {
    HabitType.PHYSICAL: <Habit>[],
    HabitType.GENERAL: <Habit>[],
    HabitType.MENTAL: <Habit>[],
  };

  Map<HabitType, List<Task>> _tasks = {
    HabitType.PHYSICAL: <Task>[],
    HabitType.GENERAL: <Task>[],
    HabitType.MENTAL: <Task>[],
  };

  // Tasks which can be completed today
  List<ExecutableTask> _executableTasks = <ExecutableTask>[];
  get executableTasks => _executableTasks;

  /// Resets all [UserModel] properties.
  void reset() {
    _user = UserModel();
    _userId = null;

    _loading = false;
    _isInitialized = false;
    _executableTasksLoaded = false;
    _password = null;
    _metaLevel = 1;
    _metaXp = 0;
    _habits = {};
    _tasks = {};
    _executableTasks = <ExecutableTask>[];

    for (HabitType type in HabitType.values) {
      _habits[type] = <Habit>[];
      _tasks[type] = <Task>[];
    }
  }

  /// Sets users credentials (email, username, password).
  void setCredentials(String email, String username, String password) {
    user.email = email;
    user.username = username;
    _password = password;
    notifyListeners();
  }

  /// Gets tasks based on provided [HabitType].
  /// Returns all tasks if no type is provided.
  List<Task>? getTasksFromType(HabitType? type) {
    if (type == null) {
      return _tasks[HabitType.PHYSICAL]! +
          _tasks[HabitType.GENERAL]! +
          _tasks[HabitType.MENTAL]!;
    }

    return _tasks[type];
  }

  /// Gets habits based on provided [HabitType].
  /// Returns habits based on user preferences if [type] is null.
  List<Habit> getHabitsFromType(HabitType? type) {
    if (type == null) {
      return getCurrentHabits();
    }

    return _habits[type] ?? [];
  }

  /// Gets habits based on the users currently selected preferences in [user.selectedHabits].
  List<Habit> getCurrentHabits() {
    List<Habit> habits = [];

    for (var type in HabitType.values) {
      if (user.selectedHabits[type]!) {
        habits += _habits[type]!;
      }
    }

    return habits;
  }

  /// Gets all [_executableTasks] scheduled on provided date.
  List<ExecutableTask> getExecutableTasksFromDate(DateTime day) {
    var tasks = <ExecutableTask>[];

    for (ExecutableTask task in _executableTasks) {
      if (isSameDay(task.scheduledDateTime, day)) {
        tasks.add(task);
      }
    }

    return tasks;
  }

  /// Sets executable tasks that can be completed in provided day.
  Future<void> setExecutableTasks(DateTime today) async {
    _executableTasksLoaded = false;
    notifyListeners();

    // Tasks can be completed for TASK_RANGE number of days behind their scheduling.
    var from = today.subtract(Duration(days: TASK_RANGE));

    // Fetch users completed task history.
    final completedTasks = await userRepository.getCompletedTasks(userId);

    // Executable tasks are tasks which are scheduled for TASK_RANGE number of days behind.
    while (today.difference(from).inDays >= 0) {
      List<Task> tasks = getTasksFromDate(from);
      _executableTasks = <ExecutableTask>[];

      for (var task in tasks) {
        final scheduledDateTime = DateTime(from.year, from.month, from.day);
        var executableTask = ExecutableTask(
          task: task,
          scheduledDateTime: scheduledDateTime,
          notifications: task.notifications,
        );

        if (completedTasks.contains(
          getCompletedTaskId(task, scheduledDateTime),
        )) {
          executableTask.setIsDone = true;
        }

        _executableTasks.add(executableTask);
        //executableTask.scheduleNotification();
      }

      from = from.add(Duration(days: 1));
    }

    _executableTasksLoaded = true;
    notifyListeners();
  }

  /// Gets all scheduled [HabitType]s on the provided day.
  List<Task> getScheduledHabitTypes(DateTime day) {
    final List<Task> taskTypes = [];
    var tasksOnDay = getTasksFromDate(day);

    for (Task task in tasksOnDay) {
      var typeExists = taskTypes.any((t) => t.type == task.type);
      if (!typeExists) {
        taskTypes.add(task);
      }
    }

    return taskTypes;
  }

  /// Gets all scheduled tasks on provided date from [_tasks].
  List<Task> getTasksFromDate(DateTime currentDateTime) {
    final List<Task> allTasks = [];

    for (final type in HabitType.values) {
      final tasksOfType = _tasks[type] ?? [];

      if (user.selectedHabits[type] ?? false) {
        for (final task in tasksOfType) {
          final taskStartDateTime = task.scheduledDay.toDateTime(
            date: task.startDateTime,
          );

          final taskStartDate = stripTime(taskStartDateTime);
          final currentDate = stripTime(currentDateTime);
          final diff = currentDate.difference(taskStartDate).inDays;

          final isSameWeekday =
              currentDateTime.weekday == task.scheduledDay.index + 1;
          final isAfterOrToday =
              currentDate.isAfter(task.startDateTime) ||
              isSameDay(currentDate, task.startDateTime);

          switch (task.scheduledFrequency) {
            case Frequency.DAILY:
              if (isAfterOrToday) allTasks.add(task);
              break;
            case Frequency.WEEKLY:
              if (isAfterOrToday && isSameWeekday) allTasks.add(task);
              break;
            case Frequency.BYWEEKLY:
              if (isAfterOrToday && isSameWeekday) {
                if (diff >= 0 && diff % 14 == 0) {
                  allTasks.add(task);
                }
              }
              break;
            case Frequency.MONTHLY:
              if (currentDateTime.day == taskStartDateTime.day &&
                  isAfterOrToday) {
                allTasks.add(task);
              }
              break;
          }
        }
      }
    }

    return allTasks;
  }

  /// Set selected habits
  void setSelectedHabits(bool physical, bool general, bool mental) {
    user.selectedHabits[HabitType.PHYSICAL] = physical;
    user.selectedHabits[HabitType.GENERAL] = general;
    user.selectedHabits[HabitType.MENTAL] = mental;

    setExecutableTasks(DateTime.now());
    notifyListeners();
  }

  /// Updates users [_metaLevel].
  void updateMetaLevel(int summedXp, int Function(int level) getMaxXp) {
    var newLevel = 1;
    var remainingXp = summedXp;

    while (true) {
      int requiredXp = getMaxXp(newLevel);
      if (remainingXp < requiredXp) break;

      remainingXp -= requiredXp;
      newLevel++;
    }

    _metaLevel = newLevel;
    _metaXp = remainingXp;
  }

  /// Increments [user.experience] and stores it to the Firestore.
  Future<void> incrementExperience(
    HabitType type,
    DateTime scheduledDate,
    ValueNotifier<int> experience,
  ) async {
    var incrementedExperience = user.experience[type]!;
    user.experience[type] = incrementedExperience.increment(
      scheduledDate,
      experience,
    );
    await userRepository.updateExperience(userId, user.experience);
    updateMetaLevel(
      Experience.getMetaXp(user.experience),
      (level) => Experience.getMetaMaxXp(user.experience),
    );
  }

  /// Overwrites [_tasks] with new values.
  void setHabits(List<Habit> habits) {
    for (var habit in HabitType.values) {
      _habits[habit] = [];
    }

    for (Habit habit in habits) {
      addHabit(habit);
    }
  }

  /// Ads habit to [_habits].
  void addHabit(Habit habit) {
    _habits[habit.type]?.add(habit);
    notifyListeners();
  }

  /// deletes habit from [_habits].
  void deleteHabit(Habit habit) {
    final habits = _habits[habit.type];
    if (habits == null) return;

    habits.removeWhere((habitEntry) => habit.id == habitEntry.id);
    notifyListeners();
  }

  /// Overwrites [_tasks] with new values.
  void setTasks(List<Task> tasks) {
    // Clear tasks
    for (var habit in HabitType.values) {
      _tasks[habit] = [];
    }

    for (Task task in tasks) {
      addTask(task);
    }
  }

  /// Ads task to [_tasks].
  void addTask(Task task) {
    _tasks[task.type]?.add(task);
    notifyListeners();
  }

  /// Deletes task from [_tasks].
  void deleteTask(Task newTask) {
    final tasks = _tasks[newTask.type];
    if (tasks == null) return;

    tasks.removeWhere((taskEntry) => newTask.id == taskEntry.id);
    notifyListeners();
  }

  /// updates task in [_tasks] with new values.
  Task? updateTask(
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
    if (tasks == null) return null;

    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      var task = tasks[index].copyWith(
        title: title,
        subtitle: subtitle,
        description: description,
        scheduledFrequency: frequency,
        scheduledDay: day,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        notifications: notifications,
      );

      tasks[index] = task;
    }

    notifyListeners();
    return tasks[index];
  }

  /// Creates user in the database.
  Future<void> createUser() async {
    UserCredential? credential;

    try {
      // Create Firebase Auth user
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      _userId = credential.user?.uid;

      // Create Firestore user document
      await userRepository.saveUser(userId, user);
      await taskRepository.saveAll(userId, getTasksFromType(null));
      await habitRepository.saveAll(userId, getHabitsFromType(null));
    } catch (e) {
      // Something went wrong, rollback
      print('Registration failed: $e');

      // Rollback Auth user if it was created
      if (credential != null) {
        try {
          await credential.user?.delete();
          await userRepository.deleteUser(userId);
          reset();
          print('Rolled back Auth user and deleted document in Firebase.');
        } catch (deleteError) {
          print(
            'Failed to delete Auth user and rollback Firebase: $deleteError',
          );
        }
      }

      // Rethrow to let caller know registration failed
      rethrow;
    }

    setExecutableTasks(DateTime.now());
    notifyListeners();
  }

  /// Patches user attributes in the database and overrides user plan.
  Future<void> patchUser() async {
    await userRepository.updateUser(userId, user.toMap());
    await taskRepository.overrideAll(userId, getTasksFromType(null)!);
    await habitRepository.overrideAll(userId, getHabitsFromType(null)!);

    setExecutableTasks(DateTime.now());
    notifyListeners();
  }

  /// Initializes the [UserModel] instance.
  Future<void> initialize(String? userId) async {
    if (_isInitialized) return;

    _loading = true;
    notifyListeners();

    var res = await userRepository.fetchUser(userId);

    if (res != null && userId != null) {
      _user = res;
      _userId = userId;

      var habits = await habitRepository.fetchAll(userId);
      setHabits(habits);

      var tasks = await taskRepository.fetchAll(userId);
      setTasks(tasks);
    } else {
      _user = UserModel();
    }

    // Set tasks that are available for execution
    setExecutableTasks(DateTime.now());
    _isInitialized = true;
    _loading = false;
    notifyListeners();
  }
}
