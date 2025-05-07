import 'package:flutter/material.dart';
import 'package:morphe/components/habit_tile.dart';
import 'package:morphe/components/task_tile.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/utils/constants.dart';

import '../components/screen_title.dart';
import '../components/subtitle.dart';
import '../components/task_list.dart';
import '../model/task_data.dart';
import '../utils/enums.dart';
import 'describe_your_goals.dart';

class PhysicalPlanOverviewScreen extends StatelessWidget {
  static String id = '/physical_plan_overview_screen';

  const PhysicalPlanOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTitle(title: "PLAN OVERVIEW"),
          Subtitle(
            title: "PHYSICAL",
            subtitle: "Workout plan",
            color: kPhysicalColor,
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TasksList(taskData: TaskData()),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Recommended habits",
                      style: kTitleTextStyle.copyWith(
                        color: kPhysicalColor,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  HabitTile(habit: "15000 daily steps", description: "Walk"),
                  HabitTile(
                    habit: "Eat healthy",
                    description: "Eat vegetables and unprocessed foods",
                  ),
                  HabitTile(
                    habit: "Prioritise sleep",
                    description:
                        "Go to sleep and wake up at the same time every day and get 7-9 hours of sleep",
                  ),
                ],
              ),
            ),
          ),
          ArrowButton(
            title: "CONFIRM",
            onPressed: () {
              Navigator.pushNamed(context, DescribeYourGoals.id);
            },
          ),
        ],
      ),
    );
  }
}
