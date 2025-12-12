import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../model/task.dart';
import '../utils/functions.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezones
    tzdata.initializeTimeZones();

    final localTzResult = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTzResult.identifier));

    // Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // IOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  /// Notification detail setup
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_task_channel', // channel id
        'Scheduled Task Notifications', // channel name
        channelDescription: 'Notifications for scheduled tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Show Notification (immediate)
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(id, title, body, _notificationDetails());
  }

  /// Cancel Notification
  Future<void> cancelTaskNotification(Task task) async {
    final id = taskIdToNotificationId(task.id);

    await notificationsPlugin.cancel(id);
  }

  /// Schedule Task
  Future<void> scheduleTaskNotification(Task task) async {
    if (!task.notifications) {
      return;
    }

    final id = taskIdToNotificationId(task.id);
    final title = task.title;
    final body = task.subtitle.isNotEmpty ? task.subtitle : task.description;

    final tz.TZDateTime next = _nextScheduledTime(task);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      next,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: task.id,
    );
  }

  tz.TZDateTime _nextScheduledTime(Task task) {
    final now = tz.TZDateTime.now(tz.local);
    final start = task.startDateTime;

    // The time of day for the notification
    final time = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );

    // If the time is in the future today, schedule for today
    if (time.isAfter(now)) {
      return time;
    }
    // Otherwise, schedule for tomorrow
    return time.add(const Duration(days: 1));
  }

  /// Check if a notification with specific ID is scheduled
  Future<bool> isNotificationScheduled(int notificationId) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await notificationsPlugin.pendingNotificationRequests();

    // Check if any pending notification has the matching ID
    return pendingNotifications.any(
      (notification) => notification.id == notificationId,
    );
  }
}
