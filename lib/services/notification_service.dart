/*
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../model/executable_task.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  //handles: Creating, Displaying, Scheduling, Cancelling notifications
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Prepare notifications for use when the app starts.
  Future<void> init() async {
    //Defines default icon for notifications.
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS permissions & settings.
    const iosSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(initSettings);

    // Optionally configure Firebase Messaging foreground handler
    FirebaseMessaging.onMessage.listen((message) {
      // Show local notification if app is open
      _plugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'fcm_channel',
            'Push Notifications',
          ),
        ),
      );
    });
  }

  Future<void> scheduleNotification(ExecutableTask task) async {
    if (!task.notifications) return;

    final scheduledTime = tz.TZDateTime.from(task.scheduledDateTime, tz.local);

    await _plugin.zonedSchedule(
      task.task.id.hashCode ^
          task.scheduledDateTime.hashCode, // unique notification id
      task.task.title,
      task.task.description,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Optional repeat daily
    );
  }

  Future<void> cancelNotification(ExecutableTask task) async {
    await _plugin.cancel(
      task.task.id.hashCode ^
          task.scheduledDateTime.hashCode, // unique notification id
    );
  }

  Future<void> cancelAll() async => _plugin.cancelAll();
}
*/
