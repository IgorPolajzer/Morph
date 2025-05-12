import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:morphe/components/pop_ups/add_task_popup.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';

import '../components/lists/habit_list.dart';
import '../components/text/screen_title.dart';
import '../components/text/subtitle.dart';
import '../components/lists/task_list.dart';
import '../utils/enums.dart';
import 'describe_your_goals.dart';
import '../model/user.dart';

class PlanOverviewScreen extends StatefulWidget {
  static String id_physical = '/physical_plan_overview_screen';
  static String id_general = '/general_plan_overview_screen';
  static String id_mental = '/mental_plan_overview_screen';

  final HabitType type;

  const PlanOverviewScreen({required this.type, super.key});

  @override
  State<PlanOverviewScreen> createState() => _PlanOverviewScreenState();
}

class _PlanOverviewScreenState extends State<PlanOverviewScreen> {
  static bool _dataFetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dataFetched) {
        final user = Provider.of<User>(context, listen: false);
        user.getFromFireBase();
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Subtitle(
                    title: widget.type.name,
                    subtitle: "Workout plan",
                    color: widget.type.getColor(),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TasksList(type: widget.type),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              "Recommended habits",
                              style: kTitleTextStyle.copyWith(
                                color: widget.type.getColor(),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          HabitList(type: widget.type),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: widget.type.getColor(),
        foregroundColor: Theme.of(context).primaryColor,
        onPressed:
            () => showPopupCard(
              context: context,
              builder: (context) {
                return AddTaskPopUp(type: widget.type);
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
            switch (widget.type) {
              case HabitType.PHYSICAL:
                Navigator.pushNamed(context, PlanOverviewScreen.id_general);
              case HabitType.GENERAL:
                Navigator.pushNamed(context, PlanOverviewScreen.id_mental);
              case HabitType.MENTAL:
                user.updateFirebase();
                Navigator.pushNamed(context, DescribeYourGoals.id);
            }
          },
        ),
      ),
    );
  }
}
