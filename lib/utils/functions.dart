import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/task.dart';

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
