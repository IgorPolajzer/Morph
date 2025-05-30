import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/utils/enums.dart';
import 'package:morphe/utils/plan_generator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
  //print("${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}");
  await dotenv.load(fileName: ".env");
  generateAndParse(prompts);
  WidgetsFlutterBinding.ensureInitialized();
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
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Morph',
          theme: kLightTheme,
          darkTheme: kDarkTheme,
        ),
      ),
    );
  }
}
