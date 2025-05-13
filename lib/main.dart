import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morphe/screens/calendar_screen.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/screens/choose_goals_screen.dart';
import 'package:morphe/screens/describe_your_goals.dart';
import 'package:morphe/screens/login_screen.dart';
import 'package:morphe/screens/plan_overview_screen.dart';
import 'package:morphe/screens/registration_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';
import 'package:morphe/screens/wrapper_screen.dart';
import 'package:morphe/utils/enums.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'model/user_data.dart';

void main() async {
  print("${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}, ${Uuid().v4()}");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    late UserData userData = UserData();

    return ChangeNotifierProvider<UserData>(
      create: (context) => userData,
      child: MaterialApp(
        title: 'Morph',
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        initialRoute: AuthWrapperScreen.id,
        routes: {
          AuthWrapperScreen.id: (context) => AuthWrapperScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ChooseGoalsScreen.id: (context) => ChooseGoalsScreen(),
          DescribeYourGoals.id: (context) => DescribeYourGoals(),
          PlanOverviewScreen.id_physical:
              (context) => PlanOverviewScreen(type: HabitType.PHYSICAL),
          PlanOverviewScreen.id_general:
              (context) => PlanOverviewScreen(type: HabitType.GENERAL),
          PlanOverviewScreen.id_mental:
              (context) => PlanOverviewScreen(type: HabitType.MENTAL),
          CalendarScreen.id: (context) => CalendarScreen(),
        },
      ),
    );
  }
}
