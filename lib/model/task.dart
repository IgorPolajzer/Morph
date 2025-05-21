import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../utils/enums.dart';

class Task {
  String id = Uuid().v4();
  DateTime? scheduledDateTime;

  String title;
  String subtitle;
  String description;
  Frequency scheduledFrequency;
  Day scheduledDay;
  DateTime startDateTime;
  DateTime endDateTime;
  final HabitType type;
  bool notifications;
  bool isDone;

  Task({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.scheduledFrequency,
    required this.scheduledDay,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    required this.notifications,
    this.isDone = false,
  });

  factory Task.clone(Task t) {
    Task task = Task(
      title: t.title,
      subtitle: t.subtitle,
      description: t.description,
      scheduledFrequency: t.scheduledFrequency,
      scheduledDay: t.scheduledDay,
      startDateTime: t.startDateTime,
      endDateTime: t.endDateTime,
      type: t.type,
      notifications: t.notifications,
      isDone: t.isDone,
    );
    task.id = t.id;
    task.scheduledDateTime = t.scheduledDateTime;

    return task;
  }

  void toggleDone() {
    isDone = !isDone;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    var task = Task(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      scheduledFrequency: Frequency.getFrequencyFromString(
        json['scheduledFrequency'],
      ),
      scheduledDay: Day.getDayFromString(json['scheduledDay']),
      startDateTime: (json['startDateTime'] as Timestamp).toDate(),
      endDateTime: (json['endDateTime'] as Timestamp).toDate(),
      type: HabitType.getTypeFromString(json['type'] ?? ''),
      notifications: json['notifications'],
    );
    task.id = json['id'];

    return task;
  }

  static Future<List<Task>> pullFromFirebase(String id) async {
    try {
      final taskDocs =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .collection('tasks')
              .get();

      return taskDocs.docs.map((doc) => Task.fromJson(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'scheduledFrequency': scheduledFrequency.name.toLowerCase(),
      'scheduledDay': scheduledDay.name.toLowerCase(),
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'type': type.name.toLowerCase(),
      'notifications': notifications,
      'id': id,
    };
  }

  // Firebase interaction
  Future<bool> pushToFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final taskMap = {
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'scheduledFrequency': scheduledFrequency.name.toLowerCase(),
        'scheduledDay': scheduledDay.name.toLowerCase(),
        'startDateTime': Timestamp.fromDate(startDateTime),
        'endDateTime': Timestamp.fromDate(endDateTime),
        'type': type.name.toLowerCase(),
        'notifications': notifications,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .add(taskMap);

      return true;
    } catch (e) {
      print('Failed to push task to Firebase: $e');
      return false;
    }
  }
}
