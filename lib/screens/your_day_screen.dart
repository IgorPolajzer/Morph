import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/lists/daily_task_list.dart';
import '../components/text/screen_title.dart';
import '../model/user_data.dart';

class YourDayScreen extends StatelessWidget {
  static String id = '/your_day_screen';
  DateTime date = DateTime.now();

  YourDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);
    final tasks = userData.getTasks(DateTime.now());

    return PopScope(
      canPop: true, // false to disable backwards routing
      child: Scaffold(
        appBar: ScreenTitle(title: "MY DAY"),
        body: DailyTasksList(tasks: tasks),
      ),
    );
  }
}
