import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/pop_ups/add_task_popup.dart';
import 'package:morphe/components/buttons/arrow_button.dart';
import 'package:morphe/screens/calendar_screen.dart';
import 'package:morphe/utils/constants.dart';
import 'package:provider/provider.dart';

import '../components/lists/habit_list.dart';
import '../components/text/screen_title.dart';
import '../components/text/subtitle.dart';
import '../components/lists/task_list.dart';
import '../utils/enums.dart';
import '../model/user_data.dart';

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
  void toNextPlanOverview(UserData userData) {
    var selectedHabits = userData.selectedHabits;

    switch (widget.type) {
      case HabitType.PHYSICAL:
        if (selectedHabits[HabitType.GENERAL])
          context.go(PlanOverviewScreen.id_general);
        else if (selectedHabits[HabitType.MENTAL])
          context.go(PlanOverviewScreen.id_mental);
        else {
          userData.pushToFirebase();
          context.go(CalendarScreen.id);
        }
        break;
      case HabitType.GENERAL:
        if (selectedHabits[HabitType.MENTAL])
          context.go(PlanOverviewScreen.id_mental);
        else {
          userData.pushToFirebase();
          context.go(CalendarScreen.id);
        }
        break;
      case HabitType.MENTAL:
        userData.pushToFirebase();
        context.go(CalendarScreen.id);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);

    if (userData.loading && userData.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: ScreenTitle(title: "PLAN OVERVIEW"),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Subtitle(
                  title: widget.type.name,
                  subtitle:
                      widget.type == HabitType.PHYSICAL
                          ? "Workout plan"
                          : "Recommended habits",
                  color: widget.type.getColor(),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TasksList(type: widget.type),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Recommended habits",
                                style: kTitleTextStyle.copyWith(
                                  color: widget.type.getColor(),
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Long click to delete a habit",
                                style: kPlaceHolderTextStyle.copyWith(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
            toNextPlanOverview(userData);
          },
        ),
      ),
    );
  }
}
