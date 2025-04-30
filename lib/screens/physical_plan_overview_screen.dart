import 'package:flutter/material.dart';
import 'package:morphe/components/arrow_button.dart';
import 'package:morphe/constants.dart';

import '../components/screen_title.dart';
import 'describe_your_goals.dart';

class PhysicalPlanOverViewScreen extends StatelessWidget {
  static String id = '/physical_plan_overview_screen';

  const PhysicalPlanOverViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ScreenTitle(title: "PLAN OVERVIEW"),
          Card(
            color: kTaskTileColorDark,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.circle_rounded, color: kPhysicalColor),
                  title: Text('Three-line ListTile'),
                  subtitle: Text(
                    'A sufficiently long subtitle warrants three lines.',
                  ),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
                Text("Workout with Ella"),
                Text("Workout with Ella"),
              ],
            ),
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
