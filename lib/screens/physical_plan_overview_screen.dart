import 'package:flutter/material.dart';
import 'package:morphe/components/task_tile.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/utils/constants.dart';

import '../components/screen_title.dart';
import '../components/subtitle.dart';
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
          TaskTile(
            startTime: DateTime(2025, 5, 5, 19, 0),
            endTime: DateTime(2025, 5, 5, 21, 0),
            title: "Upper body workout",
            subtitle: "Workout for the upper body",
            type: TaskType.PHYSICAL,
          ),
          TaskTile(
            startTime: DateTime(2025, 5, 6, 19, 0),
            endTime: DateTime(2025, 5, 6, 20, 0),
            title: "Lower body workout",
            subtitle: "Workout for the lower body",
            type: TaskType.PHYSICAL,
          ),
          TaskTile(
            startTime: DateTime(2025, 5, 7, 19, 0),
            endTime: DateTime(2025, 5, 7, 21, 0),
            title: "Swimming",
            subtitle: "Interval crawl swimming",
            type: TaskType.PHYSICAL,
          ),
          TaskTile(
            startTime: DateTime(2025, 5, 8, 19, 0),
            endTime: DateTime(2025, 5, 8, 21, 0),
            title: "Upper body workout",
            subtitle: "Workout for the upper body",
            type: TaskType.PHYSICAL,
          ),
          TaskTile(
            startTime: DateTime(2025, 5, 9, 19, 0),
            endTime: DateTime(2025, 5, 9, 21, 0),
            title: "Lower body workout",
            subtitle: "Workout for the lower body",
            type: TaskType.PHYSICAL,
          ),
          Spacer(),
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
