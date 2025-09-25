import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/model/executable_task.dart';
import 'package:provider/provider.dart';

import '../../components/lists/habit_list.dart';
import '../../components/lists/task_list.dart';
import '../../components/pop_ups/add_task_popup.dart';
import '../../components/text/screen_title.dart';
import '../../components/text/subtitle.dart';
import '../../model/task.dart';
import '../../state/user_data.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';

class EditPlanScreen extends StatefulWidget {
  static String id_physical = '/edit_physical_plan_screen';
  static String id_general = '/edit_general_plan_screen';
  static String id_mental = '/edit_mental_plan_screen';

  final HabitType type;

  const EditPlanScreen({required this.type, super.key});

  @override
  State<EditPlanScreen> createState() => _EditPlanScreenState();
}

class _EditPlanScreenState extends State<EditPlanScreen> {
  ValueNotifier<List<Task>> _scheduledTasks = ValueNotifier([]);
  ValueNotifier<List<ExecutableTask>> _executableTasks = ValueNotifier([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);

    DateTime date = DateTime.now();
    _scheduledTasks.value = userData.getTasksFromDate(date);
    _executableTasks.value = userData.getExecutableTasksFromDate(date);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: ScreenTitle(title: "${widget.type.name} PLAN"),
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
                    subtitle: "Recommended tasks",
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
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          HabitList(type: widget.type, modifiable: true),
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
      ),
    );
  }
}
