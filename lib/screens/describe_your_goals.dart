import 'package:flutter/material.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/components/buttons/goal_radio_button.dart';
import 'package:morphe/screens/plan_overview_screen.dart';
import 'package:provider/provider.dart';

import '../components/text_fields/describe_goal_text_field.dart';
import '../components/text/screen_title.dart';
import '../model/user.dart';
import '../utils/enums.dart';

class DescribeYourGoals extends StatelessWidget {
  static String id = '/describe_your_goals_screen';

  const DescribeYourGoals({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);

    return Scaffold(
      appBar: ScreenTitle(title: "DESCRIBE YOUR GOALS"),
      body: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  DescribeGoalField(
                    type: HabitType.PHYSICAL,
                    title: "PHYSICAL",
                    hint: "",
                    description:
                        "Describe your physical goals.\nExample: I want to reach a healthy bodyfat range, improve my general strength and health. I would like to achieve those goals through weight training and swimming.",
                    enabled: user.getSelectedHabits[HabitType.PHYSICAL],
                  ),
                  DescribeGoalField(
                    type: HabitType.GENERAL,
                    title: "GENERAL",
                    hint: "",
                    description:
                        "Describe your general goals.\nExample: I want to improve adhere better to doing my chores more specifically: cleaning my room, reading at least 1 book a month, revising after my classes and working on my personal project “Morphe” at least 5 hours a week.",
                    enabled: user.getSelectedHabits[HabitType.GENERAL],
                  ),
                  DescribeGoalField(
                    type: HabitType.MENTAL,
                    title: "MENTAL",
                    hint: "",
                    description:
                        "Describe your mental goals.\nExample: I want to improve my memory, mental clarity and get better at managing stress and anxiety.",
                    enabled: user.getSelectedHabits[HabitType.MENTAL],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(
          title: "GENERATE",
          onPressed: () {
            Navigator.pushNamed(context, PlanOverviewScreen.id_physical);
          },
        ),
      ),
    );
  }
}
