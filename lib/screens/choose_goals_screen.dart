import 'package:flutter/material.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/components/goal_radio_menu.dart';
import 'package:morphe/components/rounded_button.dart';

import '../components/screen_title.dart';
import '../constants.dart';

class ChooseGoalsScreen extends StatelessWidget {
  static String id = '/choose_goals_screen';

  const ChooseGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTitle(title: "CHOOSE YOUR GOALS"),
          GoalRadioMenu(
            isChecked: false,
            checkboxCallback: (checkboxState) {},
            backgroundColor: kPhysicalColor,
            title: "PHYSICAL GOALS",
            description:
                "Improve your physical health by getting a personalised plan tailored to your to your physical goals including workout plans and general tips and recommendations which will help you transform your body.",
          ),
          GoalRadioMenu(
            isChecked: false,
            checkboxCallback: (checkboxState) {},
            backgroundColor: kGeneralColor,
            title: "GENERAL HABITS",
            description:
                "Get better at adhering to your habits by getting reminders to complete everyday chores",
          ),
          GoalRadioMenu(
            isChecked: false,
            checkboxCallback: (checkboxState) {},
            backgroundColor: kMentalColor,
            title: "MENTAL GOALS",
            description:
                "Improve your mental health and clarity by getting a plan tailored to you unique circumstances and goals.",
          ),
          Spacer(),
          ArrowButton(title: "CONFIRM", onPressed: () {}),
        ],
      ),
    );
  }
}
