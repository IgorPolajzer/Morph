import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:morphe/utils/toast_util.dart';
import 'package:pair/pair.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/habit.dart';
import '../model/task.dart';
import 'enums.dart';

DateTime toDateTime(TimeOfDay time) {
  final now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

DateTime stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

bool isToday(DateTime? date) {
  if (date == null) return false;

  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isSameDay(DateTime? dateA, DateTime? dateB) {
  return dateA?.year == dateB?.year &&
      dateA?.month == dateB?.month &&
      dateA?.day == dateB?.day;
}

String getCompletedTaskId(Task task, DateTime date) {
  return "${task.id};${date.toString()}";
}

String getUserFirebaseId() {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) throw Exception("User not authenticated");
  return currentUser.uid;
}

DateTime normalizeTime(DateTime input) {
  final now = DateTime.now();
  return DateTime(
    now.year,
    now.month,
    now.day,
    input.hour,
    input.minute,
    input.second,
  );
}

int taskIdToNotificationId(String taskId) {
  // Create a positive, bounded int ID
  return taskId.hashCode & 0x7fffffff;
}

Future<void> handlePermission(
  Permission permission,
  String name,
  BuildContext context,
) async {
  var status = await permission.request();
  permissionToast(status, name, context);
}

Pair<List<Task>, List<Habit>> createHardcodedPlan() {
  // Habits.
  final habits = [
    Habit(
      title: 'Morning Run',
      description: 'Run 3 km every morning to improve cardiovascular health.',
      type: HabitType.PHYSICAL,
      notifications: true,
    ),
    Habit(
      title: 'Read Daily',
      description: 'Read at least 30 minutes every day to expand knowledge.',
      type: HabitType.GENERAL,
      notifications: true,
    ),
    Habit(
      title: 'Meditation',
      description:
          'Meditate for 15 minutes to reduce stress and improve focus.',
      type: HabitType.MENTAL,
      notifications: true,
    ),
  ];

  // Tasks - include one task for each frequency type, all scheduled on Friday at 23:30.
  final now = DateTime.now();
  final start = now.add(const Duration(minutes: 1));

  final end1 = start.add(const Duration(minutes: 30));
  final end2 = start.add(const Duration(minutes: 30));
  final end3 = start.add(const Duration(hours: 1));
  final end4 = start.add(const Duration(minutes: 45));

  final tasks = [
    Task(
      title: 'Late Night Run',
      subtitle: 'Daily exercise',
      description: 'Quick run to close the day.',
      scheduledFrequency: Frequency.DAILY,
      scheduledDay: DayType.WEDNESDAY,
      startDateTime: start,
      endDateTime: end1,
      type: HabitType.PHYSICAL,
      notifications: true,
    ),
    Task(
      title: 'Weekly Review',
      subtitle: 'Weekly planning',
      description: 'Review progress and plan next week.',
      scheduledFrequency: Frequency.WEEKLY,
      scheduledDay: DayType.WEDNESDAY,
      startDateTime: start,
      endDateTime: end2,
      type: HabitType.GENERAL,
      notifications: true,
    ),
    Task(
      title: 'Monthly Reflection',
      subtitle: 'Monthly check-in',
      description: 'Reflect on the month and set intentions.',
      scheduledFrequency: Frequency.MONTHLY,
      scheduledDay: DayType.WEDNESDAY,
      startDateTime: start,
      endDateTime: end4,
      type: HabitType.MENTAL,
      notifications: true,
    ),
  ];

  return Pair(tasks, habits);
}
