import 'package:flutter/material.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';

import '../components/habit_list.dart';
import '../components/screen_title.dart';
import '../components/subtitle.dart';
import '../components/task_list.dart';
import '../utils/enums.dart';
import 'describe_your_goals.dart';
import '../model/user.dart';

class PhysicalPlanOverviewScreen extends StatelessWidget {
  static String id = '/physical_plan_overview_screen';

  const PhysicalPlanOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    user.getUserFromFireBase();

    return Scaffold(
      appBar: ScreenTitle(title: "PLAN OVERVIEW"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Subtitle(
                title: "PHYSICAL",
                subtitle: "Workout plan",
                color: kPhysicalColor,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TasksList(type: HabitType.PHYSICAL),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          "Recommended habits",
                          style: kTitleTextStyle.copyWith(
                            color: kPhysicalColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      HabitList(type: HabitType.PHYSICAL),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(
          title: "CONFIRM",
          onPressed: () {
            Navigator.pushNamed(context, DescribeYourGoals.id);
          },
        ),
      ),
    );
  }
}
