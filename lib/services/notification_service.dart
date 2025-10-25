import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../model/task.dart';
import '../utils/enums.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezones
    tzdata.initializeTimeZones();
    try {
      final dynamic localTzResult = await FlutterTimezone.getLocalTimezone();
      final String localTz = (localTzResult ?? '').toString();
      if (localTz.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(localTz));
      } else {
        tz.setLocalLocation(tz.getLocation('UTC'));
      }
    } catch (_) {
      // Fallback to UTC if timezone name is unavailable or any error occurs
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

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

  // Notification detail setup
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

  // Show Notification (immediate)
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(id, title, body, _notificationDetails());
  }

  int _taskIdToNotificationId(String taskId) {
    // Create a positive, bounded int ID
    return taskId.hashCode & 0x7fffffff;
  }

    Future<void> cancelTaskNotification(Task task) async {

      final id = _taskIdToNotificationId(task.id);

      await notificationsPlugin.cancel(id);

    }

  

    Future<void> requestPermissions() async {

      final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<

          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();

  

      final iOSPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<

          IOSFlutterLocalNotificationsPlugin>();

      await iOSPlugin?.requestPermissions(

        alert: true,

        badge: true,

        sound: true,

      );

    }

  

    Future<List<PendingNotificationRequest>> getPendingNotifications() async {

      return await notificationsPlugin.pendingNotificationRequests();

    }

  

    Future<NotificationAppLaunchDetails?> getNotificationAppLaunchDetails() async {

      return await notificationsPlugin.getNotificationAppLaunchDetails();

    }

  

    Future<void> scheduleTask(Task task) async {

      if (!task.notifications) {

        await cancelTaskNotification(task);

        return;

      }

  

    final id = _taskIdToNotificationId(task.id);
    final title = task.title;
    final body = task.subtitle.isNotEmpty ? task.subtitle : task.description;

    final tz.TZDateTime next = _nextScheduledTime(task);

    // Choose repeating strategy depending on frequency
    DateTimeComponents? matchComponents;
    switch (task.scheduledFrequency) {
      case Frequency.DAILY:
        matchComponents = DateTimeComponents.time;
        break;
      case Frequency.WEEKLY:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case Frequency.MONTHLY:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
      case Frequency.BYWEEKLY:
        matchComponents =
            null; // We'll schedule one and re-schedule on app start/updates
        break;
    }

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      next,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: matchComponents,
      payload: task.id,
    );
  }

    // Compute the next scheduled time in local tz
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
  
      switch (task.scheduledFrequency) {
        case Frequency.DAILY:
          // If the time is in the future today, schedule for today
          if (time.isAfter(now)) {
            return time;
          }
          // Otherwise, schedule for tomorrow
          return time.add(const Duration(days: 1));
  
        case Frequency.WEEKLY:
          // The target weekday (1=Monday, 7=Sunday)
          final targetWeekday = task.scheduledDay.index + 1;
  
          // Start with today's date and the task's time
          var scheduled = time;
  
          // If the scheduled time on the target day is in the past, advance to the next week
          while (scheduled.weekday != targetWeekday || scheduled.isBefore(now)) {
            scheduled = scheduled.add(const Duration(days: 1));
          }
          return scheduled;
  
        case Frequency.BYWEEKLY:
          // Find the last scheduled date, or use the start date if none
          final lastScheduled = task.startDateTime;
  
          var candidate = tz.TZDateTime(
            tz.local,
            lastScheduled.year,
            lastScheduled.month,
            lastScheduled.day,
            start.hour,
            start.minute,
          );
  
          // If the candidate is in the past, keep adding 14 days until it's in the future
          while (candidate.isBefore(now)) {
            candidate = candidate.add(const Duration(days: 14));
          }
          return candidate;
  
        case Frequency.MONTHLY:
          var scheduled = tz.TZDateTime(
            tz.local,
            now.year,
            now.month,
            start.day,
            start.hour,
            start.minute,
          );
  
          // If this month's scheduled date is in the past, move to the next month
          if (scheduled.isBefore(now)) {
            scheduled = tz.TZDateTime(
              tz.local,
              now.year,
              now.month + 1,
              start.day,
              start.hour,
              start.minute,
            );
          }
  
          // Handle cases where the day doesn't exist in the next month (e.g., 31st in Feb)
          // `TZDateTime` automatically handles this by rolling over to the next month,
          // so we need to bring it back to the last day of the correct month.
          if (scheduled.day != start.day) {
            scheduled = tz.TZDateTime(
              tz.local,
              scheduled.year,
              scheduled.month,
              0, // 0th day of the next month gives the last day of the current month
              start.hour,
              start.minute,
            );
          }
          return scheduled;
      }
    }}
