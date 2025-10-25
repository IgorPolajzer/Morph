import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:morphe/model/experience.dart';
import 'package:morphe/services/notification_service.dart';
import 'package:morphe/state/connectivity_notifier.dart';
import 'package:morphe/utils/enums.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'model/habit.dart';
import 'model/task.dart';
import 'model/user_model.dart';
import 'repositories/impl/habit_hive_repository.dart';
import 'repositories/impl/task_hive_repository.dart';
import 'repositories/impl/user_hive_repository.dart';
import 'state/user_data.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var status = await Permission.notification.status;

  if (!status.isGranted) {
    status = await Permission.notification.request();
  }

  await NotificationService().initialize();

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

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive and register adapters
  await Hive.initFlutter();

  // Enums.
  Hive.registerAdapter(HabitTypeAdapter());
  Hive.registerAdapter(DayAdapter());
  Hive.registerAdapter(FrequencyAdapter());
  Hive.registerAdapter(ExperienceAdapter());

  // Models.
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(HabitAdapter());

  // Open Hive boxes
  /*final userBox = await Hive.openBox<UserModel>('users');
  final habitBox = await Hive.openBox<Habit>('habits');
  final taskBox = await Hive.openBox<Task>('tasks');*/

  // Initialize repositories
  /*final userHiveRepo = UserHiveRepository(userBox);
  final taskHiveRepo = TaskHiveRepository(taskBox);
  final habitHiveRepo = HabitHiveRepository(habitBox);*/

  // Initialize UserData state
  final userData = UserData(
    //userHiveRepository: userHiveRepo,
    //taskHiveRepository: taskHiveRepo,
    //habitHiveRepository: habitHiveRepo,
  );

  await userData.initialize(FirebaseAuth.instance.currentUser?.uid);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>.value(value: userData),
        ChangeNotifierProvider(create: (_) => ConnectivityNotifier()),
      ],
      child: SafeArea(child: MyApp(userData: userData)),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserData userData;

  const MyApp({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(1.0)),
          child: MaterialApp.router(
            routerConfig: router,
            title: 'Morph',
            theme: kLightTheme,
            darkTheme: kDarkTheme,
          ),
        );
      },
    );
  }
}
