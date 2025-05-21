import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/tiles/task_tile.dart';

import '../../model/task.dart';
import '../pop_ups/show_more_popup.dart';

class DailyTasksList extends StatefulWidget {
  final List<Task> tasks;
  final List<Task> executableDates;

  const DailyTasksList({
    required this.tasks,
    required this.executableDates,
    super.key,
  });

  @override
  State<DailyTasksList> createState() => _DailyTasksListState();
}

class _DailyTasksListState extends State<DailyTasksList> {
  @override
  Widget build(BuildContext context) {
    var executableTaskIds = [];
    for (Task task in widget.executableDates) {
      executableTaskIds.add(task.id);
    }

    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        if (executableTaskIds.contains(widget.tasks[index].id)) {
          // Executable task
          return TaskTile(
            completed: widget.tasks[index].isDone,
            task: widget.tasks[index],
            onChecked: (value) {
              setState(() {
                if (!widget.tasks[index].isDone) {
                  widget.tasks[index].isDone = value!;
                }
              });
            },
            onTap:
                () => showPopupCard(
                  context: context,
                  builder: (context) {
                    return ShowMorePopUp(
                      title: widget.tasks[index].title,
                      description: widget.tasks[index].description,
                      subtitle: widget.tasks[index].subtitle,
                    );
                  },
                  alignment: Alignment.center,
                  useSafeArea: true,
                  dimBackground: true,
                ),
          );
        } else {
          // Completed task
          return TaskTile(
            completed: widget.tasks[index].isDone,
            executable: false,
            task: widget.tasks[index],
            onTap:
                () => showPopupCard(
                  context: context,
                  builder: (context) {
                    return ShowMorePopUp(
                      title: widget.tasks[index].title,
                      description: widget.tasks[index].description,
                      subtitle: widget.tasks[index].subtitle,
                    );
                  },
                  alignment: Alignment.center,
                  useSafeArea: true,
                  dimBackground: true,
                ),
          );
        }
      },
    );
  }
}
