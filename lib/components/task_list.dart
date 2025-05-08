import 'package:flutter/material.dart';
import 'package:morphe/components/task_tile.dart';

import '../model/task_data.dart';

class TasksList extends StatelessWidget {
  final TaskData taskData;

  TasksList({required this.taskData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Makes it take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      itemBuilder: (context, index) {
        final task = taskData.tasks[index];
        return TaskTile(
          startDateTime: task.startDateTime,
          endDateTime: task.endDateTime,
          title: task.title,
          subtitle: task.subtitle,
          description: task.description,
          type: task.type,
        );
      },
      itemCount: taskData.taskCount,
    );
  }
}
