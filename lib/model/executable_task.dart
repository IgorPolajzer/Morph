import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:morphe/model/task.dart';

import '../services/notification_service.dart';
import '../utils/functions.dart';

class ExecutableTask {
  final Task task;
  final DateTime scheduledDateTime;

  bool notifications;
  bool _isDone = false;

  ExecutableTask({
    required this.task,
    required this.scheduledDateTime,
    required this.notifications,
  });

  /*
  // Prepared for notification support
  void scheduleNotification() =>
      NotificationService().scheduleNotification(this);
  void cancelNotification() => NotificationService().cancelNotification(this);
*/

  bool get isDone => _isDone;

  set setIsDone(bool value) {
    _isDone = value;
  }

  Future<void> complete() async {
    if (!_isDone) {
      _isDone = true;

      // Add task to completedTasks
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(getUserFirebaseId());

      await userDoc.update({
        'completedTasks': FieldValue.arrayUnion([
          getCompletedTaskId(task, scheduledDateTime),
        ]),
      });
    }
  }
}
