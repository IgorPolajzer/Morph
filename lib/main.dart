import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:morphe/screens/edit_task_screen.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/screens/choose_goals_screen.dart';
import 'package:morphe/screens/describe_your_goals.dart';
import 'package:morphe/screens/login_screen.dart';
import 'package:morphe/screens/physical_plan_overview_screen.dart';
import 'package:morphe/screens/registration_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'model/habit_data.dart';
import 'model/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    late User userData = User();
    late HabitData habitData = HabitData();

    return ChangeNotifierProvider<User>(
      /*    return ChangeNotifierProvider<HabitData>(
      create: (context) => habitData,*/
      create: (context) => userData,
      child: MaterialApp(
        title: 'Morph',
        theme: kLightTheme,
        darkTheme: kDarkTheme,
        //initialRoute: WelcomeScreen.id,
        initialRoute: ChooseGoalsScreen.id, //Development purposes
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          ChooseGoalsScreen.id:
              (context) => ChooseGoalsScreen(userData: userData),
          DescribeYourGoals.id: (context) => DescribeYourGoals(),
          PhysicalPlanOverviewScreen.id:
              (context) => PhysicalPlanOverviewScreen(habitData: habitData),
          EditTaskScreen.id: (context) => EditTaskScreen(),
        },
      ),
    );
  }
}
