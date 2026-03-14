import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../model/task.dart';
import '../utils/functions.dart';
import '../utils/enums.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal({
    FlutterLocalNotificationsPlugin? notificationsPlugin,
    FlutterTimezone? flutterTimezone,
  }) : notificationsPlugin =
           notificationsPlugin ?? FlutterLocalNotificationsPlugin(),
       _flutterTimezone = flutterTimezone ?? FlutterTimezone();

  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final FlutterTimezone _flutterTimezone;

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

  /// Schedule Task with frequency support
  Future<void> scheduleTaskNotification(Task task) async {
    if (!task.notifications) {
      return;
    }

    final id = taskIdToNotificationId(task.id);
    final title = task.title;
    final body = task.subtitle.isNotEmpty ? task.subtitle : task.description;

    final details = _getSchedulingDetails(task);

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      details.scheduledTime,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: details.matchComponents,
      payload: task.id,
    );
  }

  /// Get scheduling details based on frequency
  ({tz.TZDateTime scheduledTime, DateTimeComponents? matchComponents})
  _getSchedulingDetails(Task task) {
    final now = tz.TZDateTime.now(tz.local);
    final start = task.startDateTime;

    // Create a time today at the scheduled hour/minute.
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );

    switch (task.scheduledFrequency) {
      case Frequency.DAILY:
        // If time has passed today, schedule for tomorrow.
        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }
        return (
          scheduledTime: scheduledTime,
          matchComponents: DateTimeComponents.time,
        );

      case Frequency.WEEKLY:
        return (
          scheduledTime: _nextWeeklyOccurrence(
            scheduledTime,
            task.scheduledDay.dayTypeToDay(),
            now,
          ),
          matchComponents: DateTimeComponents.dayOfWeekAndTime,
        );

      case Frequency.MONTHLY:
        return (
          scheduledTime: _nextMonthlyOccurrence(scheduledTime, now, start),
          matchComponents: DateTimeComponents.dayOfMonthAndTime,
        );
    }
  }

  /// Calculate next weekly occurrence
  tz.TZDateTime _nextWeeklyOccurrence(
    tz.TZDateTime scheduledTime,
    Day scheduledDay,
    tz.TZDateTime now,
  ) {
    // Convert Day enum to weekday (1 = Monday, 7 = Sunday)
    final targetWeekday = _dayToWeekday(scheduledDay);
    final currentWeekday = scheduledTime.weekday;

    int daysToAdd = targetWeekday - currentWeekday;

    // If target day is earlier in the week or same day but time has passed
    if (daysToAdd < 0 || (daysToAdd == 0 && scheduledTime.isBefore(now))) {
      daysToAdd += 7; // Move to next week
    }

    return scheduledTime.add(Duration(days: daysToAdd));
  }

  /// Calculate next monthly occurrence
  tz.TZDateTime _nextMonthlyOccurrence(
    tz.TZDateTime scheduledTime,
    tz.TZDateTime now,
    DateTime startDateTime,
  ) {
    // Use the day of month from start date
    final targetDay = startDateTime.day;

    // Try this month first
    tz.TZDateTime nextMonthly = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      targetDay,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    // If the date has passed or is invalid, move to next month
    if (nextMonthly.isBefore(now) || nextMonthly.day != targetDay) {
      // Move to next month
      final nextMonth =
          scheduledTime.month == 12
              ? tz.TZDateTime(
                tz.local,
                scheduledTime.year + 1,
                1,
                targetDay,
                scheduledTime.hour,
                scheduledTime.minute,
              )
              : tz.TZDateTime(
                tz.local,
                scheduledTime.year,
                scheduledTime.month + 1,
                targetDay,
                scheduledTime.hour,
                scheduledTime.minute,
              );

      // Handle months with fewer days (e.g., Feb 31 -> Feb 28/29)
      if (nextMonth.day != targetDay) {
        // Use the last day of the month instead
        nextMonthly = tz.TZDateTime(
          tz.local,
          nextMonth.year,
          nextMonth.month + 1,
          0, // Day 0 of next month = last day of this month
          scheduledTime.hour,
          scheduledTime.minute,
        );
      } else {
        nextMonthly = nextMonth;
      }
    }

    return nextMonthly;
  }

  /// Convert Day enum to weekday number
  int _dayToWeekday(Day day) {
    switch (day) {
      case Day.monday:
        return DateTime.monday;
      case Day.tuesday:
        return DateTime.tuesday;
      case Day.wednesday:
        return DateTime.wednesday;
      case Day.thursday:
        return DateTime.thursday;
      case Day.friday:
        return DateTime.friday;
      case Day.saturday:
        return DateTime.saturday;
      case Day.sunday:
        return DateTime.sunday;
    }
  }

  /// Check if a notification with specific ID is scheduled
  Future<bool> isNotificationScheduled(int notificationId) async {
    final List<PendingNotificationRequest> pendingNotifications =
        await notificationsPlugin.pendingNotificationRequests();

    return pendingNotifications.any(
      (notification) => notification.id == notificationId,
    );
  }
}
