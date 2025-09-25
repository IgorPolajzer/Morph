import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/components/buttons/goal_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../components/text/screen_title.dart';
import '../../state/user_data.dart';
import '../../utils/constants.dart';
import 'describe_your_goals_screen.dart';

class ChooseGoalsScreen extends StatefulWidget {
  static String id = '/choose_goals_screen';

  const ChooseGoalsScreen({super.key});

  @override
  State<ChooseGoalsScreen> createState() => _ChooseGoalsScreenState();
}

class _ChooseGoalsScreenState extends State<ChooseGoalsScreen> {
  bool physical = false;
  bool general = false;
  bool mental = false;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      appBar: ScreenTitle(title: "CHOOSE YOUR GOALS"),
      body: SingleChildScrollView(
        // Make the entire body scrollable
        child: Column(
          children: [
            SizedBox(height: 20),
            GoalRadioButton(
              isChecked: physical,
              checkboxCallback: (checkboxState) {
                setState(() {
                  physical = checkboxState;
                });
              },
              backgroundColor: kPhysicalColor,
              title: "PHYSICAL GOALS",
              description:
                  "Improve your physical health by getting a personalised plan tailored to your physical goals including workout plans and general tips and recommendations which will help you transform your body.",
            ),
            GoalRadioButton(
              isChecked: general,
              checkboxCallback: (checkboxState) {
                setState(() {
                  general = checkboxState;
                });
              },
              backgroundColor: kGeneralColor,
              title: "GENERAL GOALS",
              description:
                  "Get better at adhering to your habits by getting reminders to complete everyday chores",
            ),
            GoalRadioButton(
              isChecked: mental,
              checkboxCallback: (checkboxState) {
                setState(() {
                  mental = checkboxState;
                });
              },
              backgroundColor: kMentalColor,
              title: "MENTAL GOALS",
              description:
                  "Improve your mental health and clarity by getting a plan tailored to your unique circumstances and goals.",
            ),
            SizedBox(height: 20), // Optional spacing before the bottom bar
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ArrowButton(
          title: "CONFIRM",
          onPressed: () {
            // Minimum one goal.
            if (!general && !physical && !mental) {
              toastification.show(
                context: context,
                title: Text('Invalid choice'),
                description: Text('You have to choose at least one habit type'),
                type: ToastificationType.info,
                autoCloseDuration: Duration(seconds: 3),
              );
            } else {
              userData.setSelectedHabits(physical, general, mental);
              context.push(DescribeYourGoalsScreen.id);
            }
          },
        ),
      ),
    );
  }
}
