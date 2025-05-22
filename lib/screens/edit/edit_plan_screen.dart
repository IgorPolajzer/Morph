import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/components/buttons/goal_radio_button.dart';
import 'package:provider/provider.dart';

import '../../components/text/screen_title.dart';
import '../../model/user_data.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../core/profile_screen.dart';

class EditPlanScreen extends StatefulWidget {
  static String id = '/edit_plan_screen';

  const EditPlanScreen({super.key});

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  late bool physical;
  late bool general;
  late bool mental;

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);

    physical = userData.selectedHabits[HabitType.PHYSICAL];
    general = userData.selectedHabits[HabitType.GENERAL];
    mental = userData.selectedHabits[HabitType.MENTAL];
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      appBar: ScreenTitle(title: "EDIT PLAN"),
      body: SingleChildScrollView(
        // Make the entire body scrollable
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Change your selected habits",
                style: kTitleTextStyle.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 22,
                ),
              ),
            ),
            GoalRadioButton(
              editable: true,
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
              editable: true,
              isChecked: general,
              checkboxCallback: (checkboxState) {
                setState(() {
                  general = checkboxState;
                });
              },
              backgroundColor: kGeneralColor,
              title: "GENERAL HABITS",
              description:
                  "Get better at adhering to your habits by getting reminders to complete everyday chores",
            ),
            GoalRadioButton(
              editable: true,
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
            userData.setSelectedHabits(physical, general, mental);
            userData.pushSelectedHabitsToFirebase();
            context.pushReplacement(ProfileScreen.id);
          },
        ),
      ),
    );
  }
}
