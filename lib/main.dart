import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:morphe/services/notification_service.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/utils/enums.dart';
import 'package:provider/provider.dart';

import 'config/router_config.dart';
import 'model/user_data.dart';

Map<HabitType, String> prompts = {
  HabitType.PHYSICAL:
      "I want to lose body fat and build muscle. I’m not sure how, but I enjoy swimming and want to feel more athletic overall.",
  HabitType.GENERAL:
      "I want to be more organized in my daily life. My room and car are often messy, and I forget to walk my dog or drink enough water.",
  HabitType.MENTAL:
      "I want to improve my focus and reduce stress. I often feel anxious and distracted, and I’d like to get better at staying calm and consistent while working.",
};

void main() async {
  await dotenv.load(fileName: ".env");
  //await generateAndParse(prompts);
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: [
      'd68e3860-8865-46f9-8339-8ca0d3b248e0',
      '5da57a97-f5d7-4da7-be5c-23f2b71bd3bd',
    ],
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  //await NotificationService().init();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserData userData = UserData();

  @override
  void initState() {
    // User is logged in
    if (FirebaseAuth.instance.currentUser != null) {
      if (!userData.loading && !userData.isInitialized) {
        userData.pullFromFireBase();
      }
    }
    // TODO handle if network isn't available

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserData>(
      create: (context) => userData,
      child: SafeArea(
        child: Builder(
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(1.0),
              ), // Lock text scale for all devices
              child: MaterialApp.router(
                routerConfig: router,
                title: 'Morph',
                theme: kLightTheme,
                darkTheme: kDarkTheme,
              ),
            );
          },
        ),
      ),
    );
  }
}
