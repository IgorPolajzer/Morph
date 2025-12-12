import 'package:flutter/material.dart';
import 'package:morphe/components/lists/habit_list.dart';
import 'package:morphe/model/executable_task.dart';
import 'package:provider/provider.dart';

import '../../components/lists/daily_task_list.dart';
import '../../components/text/screen_title.dart';
import '../../model/habit.dart';
import '../../model/task.dart';
import '../../state/user_data.dart';
import '../../utils/constants.dart';

class YourDayScreen extends StatefulWidget {
  static String id = '/your_day_screen';

  YourDayScreen({super.key});

  @override
  State<YourDayScreen> createState() => _YourDayScreenState();
}

class _YourDayScreenState extends State<YourDayScreen> {
  final ValueNotifier<List<Task>> _scheduledTasks = ValueNotifier([]);
  final ValueNotifier<List<ExecutableTask>> _executableTasks = ValueNotifier([]);
  final ValueNotifier<List<Habit>> _habits = ValueNotifier([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);

    var date = DateTime.now();
    _scheduledTasks.value = userData.getTasksFromDate(date);
    _executableTasks.value = userData.getExecutableTasksFromDate(date);
    _habits.value = userData.getHabitsFromType(null);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final userData = Provider.of<UserData>(context, listen: true);

    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(
        appBar: ScreenTitle(title: "MY DAY"),
        body: ValueListenableBuilder<List<Task>>(
          valueListenable: _scheduledTasks,
          builder: (context, value, _) {
            if (!userData.executableTasksLoaded) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: DailyTasksList(
                      tasks: value,
                      executableTasks: _executableTasks.value,
                      scheduledDay: DateTime.now(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      children: [
                        Text(
                          "Recommended habits",
                          style: kTitleTextStyle.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20,
                          ),
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Theme.of(context).primaryColor,
                          indent: screenWidth / 12,
                          endIndent: screenWidth / 12,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: SingleChildScrollView(child: HabitList())),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
