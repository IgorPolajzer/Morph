import 'package:flutter/material.dart';
import 'package:morphe/model/executable_task.dart';
import 'package:provider/provider.dart';

import '../../components/lists/daily_task_list.dart';
import '../../components/text/screen_title.dart';
import '../../model/task.dart';
import '../../model/user_data.dart';

class YourDayScreen extends StatefulWidget {
  static String id = '/your_day_screen';

  YourDayScreen({super.key});

  @override
  State<YourDayScreen> createState() => _YourDayScreenState();
}

class _YourDayScreenState extends State<YourDayScreen> {
  ValueNotifier<List<Task>> _scheduledTasks = ValueNotifier([]);
  ValueNotifier<List<ExecutableTask>> _executableTasks = ValueNotifier([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userData = Provider.of<UserData>(context, listen: true);

    DateTime date = DateTime.now();
    _scheduledTasks.value = userData.getTasks(date);
    _executableTasks.value = userData.getExecutableTasks(date);
  }

  @override
  Widget build(BuildContext context) {
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
              return DailyTasksList(
                tasks: value,
                executableTasks: _executableTasks.value,
              );
            }
          },
        ),
      ),
    );
  }
}
