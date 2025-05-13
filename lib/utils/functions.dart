import 'package:flutter/material.dart';

DateTime toDateTime(TimeOfDay time) {
  final now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

DateTime stripTime(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

int getWeekOfMonth(DateTime dt) => ((dt.day - 1) / 7).floor() + 1;
