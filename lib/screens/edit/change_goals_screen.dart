import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/buttons/goal_radio_button.dart';
import 'package:morphe/screens/edit/edit_plan_screen.dart';
import 'package:provider/provider.dart';

import '../../components/text/screen_title.dart';
import '../../repositories/impl/user_repository.dart';
import '../../state/user_data.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../onboarding/describe_your_goals_screen.dart';

class ChangeGoalsScreen extends StatefulWidget {
  static String id = '/change_habits_screen';

  const ChangeGoalsScreen({super.key});

  @override
  State<ChangeGoalsScreen> createState() => _ChangeGoalsScreenState();
}

class _ChangeGoalsScreenState extends State<ChangeGoalsScreen> {
  // Repositories
  final UserRepository userRepository = UserRepository();

  late bool physical;
  late bool general;
  late bool mental;

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<UserData>(context, listen: false);

    physical = userData.user.selectedHabits[HabitType.PHYSICAL]!;
    general = userData.user.selectedHabits[HabitType.GENERAL]!;
    mental = userData.user.selectedHabits[HabitType.MENTAL]!;
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      appBar: ScreenTitle(title: "EDIT PLAN"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                    editOnTap: () {
                      context.push(EditPlanScreen.id_physical);
                    },
                    isChecked: physical,
                    checkboxCallback: (checkboxState) async {
                      setState(() {
                        physical = checkboxState;
                      });
                      userData.setSelectedHabits(physical, general, mental);
                      await userRepository.updateUser(
                        userData.userId,
                        userData.user.toMap(),
                      );
                    },
                    backgroundColor: kPhysicalColor,
                    title: "PHYSICAL GOALS",
                    description:
                        "Improve your physical health by getting a personalised plan tailored to your physical goals including workout plans and general tips and recommendations which will help you transform your body.",
                  ),
                  GoalRadioButton(
                    editable: true,
                    editOnTap: () {
                      context.push(EditPlanScreen.id_general);
                    },
                    isChecked: general,
                    checkboxCallback: (checkboxState) async {
                      setState(() {
                        general = checkboxState;
                      });
                      userData.setSelectedHabits(physical, general, mental);
                      await userRepository.updateUser(
                        userData.userId,
                        userData.user.toMap(),
                      );
                    },
                    backgroundColor: kGeneralColor,
                    title: "GENERAL HABITS",
                    description:
                        "Get better at adhering to your habits by getting reminders to complete everyday chores",
                  ),
                  GoalRadioButton(
                    editable: true,
                    editOnTap: () {
                      context.push(EditPlanScreen.id_mental);
                    },
                    isChecked: mental,
                    checkboxCallback: (checkboxState) async {
                      setState(() {
                        mental = checkboxState;
                      });
                      userData.setSelectedHabits(physical, general, mental);
                      await userRepository.updateUser(
                        userData.userId,
                        userData.user.toMap(),
                      );
                    },
                    backgroundColor: kMentalColor,
                    title: "MENTAL GOALS",
                    description:
                        "Improve your mental health and clarity by getting a plan tailored to your unique circumstances and goals.",
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              "Generate a new personalised plan.",
              style: kTitleTextStyle.copyWith(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                context.pushReplacement(DescribeYourGoalsScreen.id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.replay,
                    size: 30,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Generate",
                      style: kPlaceHolderTextStyle.copyWith(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
