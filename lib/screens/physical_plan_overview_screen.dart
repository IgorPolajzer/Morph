import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:morphe/components/add_task_popup.dart';
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

class PhysicalPlanOverviewScreen extends StatefulWidget {
  static String id = '/physical_plan_overview_screen';

  const PhysicalPlanOverviewScreen({super.key});

  @override
  State<PhysicalPlanOverviewScreen> createState() =>
      _PhysicalPlanOverviewScreenState();
}

class _PhysicalPlanOverviewScreenState
    extends State<PhysicalPlanOverviewScreen> {
  static bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dataFetched) {
        final user = Provider.of<User>(context, listen: false);
        user.getUserFromFireBase();
        _dataFetched = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);

    return Scaffold(
      appBar: ScreenTitle(title: "PLAN OVERVIEW"),
      body: ModalProgressHUD(
        inAsyncCall: user.loading,
        child: Column(
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPhysicalColor,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed:
            () => showPopupCard(
              context: context,
              builder: (context) {
                return AddTaskPopUp();
              },
              alignment: Alignment.bottomCenter,
              useSafeArea: true,
              dimBackground: true,
            ),
        child: const Icon(Icons.add, size: 20),
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
