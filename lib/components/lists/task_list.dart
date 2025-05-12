import 'package:flutter/material.dart';
import 'package:morphe/components/tiles/task_tile.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../utils/enums.dart';

class TasksList extends StatelessWidget {
  final HabitType type;

  TasksList({required this.type});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    var tasks = user.getTasksFromType(type);

    return ListView.builder(
      shrinkWrap: true, // Makes it take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      itemBuilder: (context, index) {
        final task = tasks?[index];

        if (task != null) {
          return TaskTile(task: task);
        }
      },
      itemCount: tasks?.length,
    );
  }
}
