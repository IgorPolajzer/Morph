import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'package:morphe/services/notification_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

import '../state/user_data.dart';

void callbackDispatcher(UserData userData) {
  Workmanager().executeTask((task, inputData) async {
    if (task == "dailyTask") {
      // Get all executable tasks
      final executableTasks = userData.getExecutableTasksFromDate(DateTime.now());

      // Schedule all notifications for tasks which are executable today.
      for (var task in executableTasks) {
        NotificationService().scheduleTaskNotification(task.task);
      }

      NotificationService().showNotification(
        title: "Notification",
        body: "test",
      );

      // Reschedule for next day at 00:01
      _scheduleNotifications();
    }
    return Future.value(true);
  });
}

Duration _delayUntilMidnight() {
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1, 0, 1);
  return tomorrow.difference(now);
}

void _scheduleNotifications() {
  Workmanager().registerOneOffTask(
    "dailyTaskId",
    "dailyTask",
    initialDelay: _delayUntilMidnight(),
    constraints: Constraints(networkType: NetworkType.not_required),
  );
}

Future<UserData> initialize() async {
  // Initialize Mobile Ads
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      'd68e3860-8865-46f9-8339-8ca0d3b248e0',
      '5da57a97-f5d7-4da7-be5c-23f2b71bd3bd',
      '539d28f1-d59f-4e7f-a54e-16227139c841',
    ],
  );

  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  var status = await Permission.notification.status;
  if (!status.isGranted) {
    status = await Permission.notification.request();
  }
  await NotificationService().initialize();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize UserData state
  final userData = UserData();
  await userData.initialize(FirebaseAuth.instance.currentUser?.uid);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  _scheduleNotifications();

  return userData;
}
