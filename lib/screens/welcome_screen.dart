import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';
import 'package:morphe/screens/login_screen.dart';
import 'package:morphe/screens/registration_screen.dart';

import '../components/buttons/gradient_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'image',
                  child: Image.asset("assets/images/logo_v2.png"),
                ),
                Hero(
                  tag: 'title',
                  child: Text(
                    "Morph",
                    style: kMorphTitleStyle.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.5,
                  color: Theme.of(context).secondaryHeaderColor,
                  indent: 60,
                  endIndent: 60,
                ),
                Hero(
                  tag: 'subtext',
                  child: Text(
                    "Small Habits. Big Change.",
                    style: kMorphPhraseStyle.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GradientButton(
                myGradient: LinearGradient(
                  colors: [kPhysicalColor, kGeneralColor],
                ),
                title: 'Register',
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
              GradientButton(
                myGradient: LinearGradient(
                  colors: [kGeneralColor, kMentalColor],
                ),
                title: 'Login',
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
