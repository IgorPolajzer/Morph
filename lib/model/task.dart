import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../utils/enums.dart';

class Task {
  String title;
  String subtitle;
  String description;
  DateTime startDateTime;
  DateTime endDateTime;
  HabitType type;
  late Widget customWidget;

  bool isDone;

  Task({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    this.isDone = false,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      startDateTime: (json['startDateTime'] as Timestamp).toDate(),
      endDateTime: (json['endDateTime'] as Timestamp).toDate(),
      type: HabitType.getTypeFromString(json['type'] ?? ''),
    );
  }

  static Future<List<Task>> getTasksFromFirebase(String id) async {
    final taskDocs =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection('tasks')
            .get();

    return taskDocs.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }
}
