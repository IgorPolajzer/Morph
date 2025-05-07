import 'package:flutter/material.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/components/goal_radio_menu.dart';
import 'package:morphe/screens/physical_plan_overview_screen.dart';

import '../components/describe_goal_input_box.dart';
import '../components/screen_title.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

class DescribeYourGoals extends StatelessWidget {
  static String id = '/describe_your_goals_screen';

  const DescribeYourGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ScreenTitle(title: "DESCRIBE YOUR GOALS"),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  DescribeGoalInputBox(
                    type: TaskType.PHYSICAL,
                    title: "PHYSICAL",
                    hint: "",
                    description:
                        "Describe your physical goals.\nExample: I want to reach a healthy bodyfat range, improve my general strength and health. I would like to achieve those goals through weight training and swimming.",
                  ),
                  DescribeGoalInputBox(
                    type: TaskType.GENERAL,
                    title: "GENERAL",
                    hint: "",
                    description:
                        "Describe your general goals.\nExample: I want to improve adhere better to doing my chores more specifically: cleaning my room, reading at least 1 book a month, revising after my classes and working on my personal project “Morphe” at least 5 hours a week.",
                  ),
                  DescribeGoalInputBox(
                    type: TaskType.MENTAL,
                    title: "MENTAL",
                    hint: "",
                    description:
                        "Describe your mental goals.\nExample: I want to improve my memory, mental clarity and get better at managing stress and anxiety.",
                  ),
                ],
              ),
            ),
          ),
          ArrowButton(
            title: "GENERATE",
            onPressed: () {
              Navigator.pushNamed(context, PhysicalPlanOverviewScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
