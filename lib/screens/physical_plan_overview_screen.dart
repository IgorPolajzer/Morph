import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/utils/constants.dart';

import '../components/habit_list.dart';
import '../components/screen_title.dart';
import '../components/subtitle.dart';
import '../components/task_list.dart';
import '../model/habit_data.dart';
import '../model/task_data.dart';
import 'describe_your_goals.dart';

class PhysicalPlanOverviewScreen extends StatefulWidget {
  static String id = '/physical_plan_overview_screen';
  final HabitData habitData;

  const PhysicalPlanOverviewScreen({required this.habitData, super.key});

  @override
  State<PhysicalPlanOverviewScreen> createState() =>
      _PhysicalPlanOverviewScreenState();
}

class _PhysicalPlanOverviewScreenState
    extends State<PhysicalPlanOverviewScreen> {
  @override
  void initState() {
    super.initState();
    widget.habitData.parseHabitsFromFireBase();
  }

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
                  HabitList(),
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
