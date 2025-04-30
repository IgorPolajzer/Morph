import 'package:flutter/material.dart';
import 'package:morphe/constants.dart';
import 'package:morphe/screens/choose_goals_screen.dart';
import 'package:morphe/screens/login_screen.dart';
import 'package:morphe/screens/registration_screen.dart';
import 'package:morphe/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morph',
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      //initialRoute: WelcomeScreen.id,
      initialRoute: ChooseGoalsScreen.id, //Development purposes
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChooseGoalsScreen.id: (context) => ChooseGoalsScreen(),
      },
    );
  }
}
