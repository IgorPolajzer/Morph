import 'package:flutter/material.dart';

DateTime toDateTime(TimeOfDay time) {
  final now = new DateTime.now();
  return new DateTime(now.year, now.month, now.day, time.hour, time.minute);
}
