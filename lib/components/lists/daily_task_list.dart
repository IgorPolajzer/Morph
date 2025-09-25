import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/tiles/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import '../../model/executable_task.dart';
import '../../model/task.dart';
import '../../state/user_data.dart';
import '../pop_ups/show_more_popup.dart';

class DailyTasksList extends StatefulWidget {
  final List<Task> tasks;
  final List<ExecutableTask> executableTasks;
  final DateTime scheduledDay;

  const DailyTasksList({
    required this.tasks,
    required this.executableTasks,
    required this.scheduledDay,
    super.key,
  });

  @override
  State<DailyTasksList> createState() => _DailyTasksListState();
}

class _DailyTasksListState extends State<DailyTasksList> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);
    ValueNotifier<int> experience = ValueNotifier(20);

    var executableTaskIds = [];
    for (ExecutableTask executableTask in widget.executableTasks) {
      executableTaskIds.add(executableTask.task.id);
    }

    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        if (executableTaskIds.contains(widget.tasks[index].id)) {
          // Executable task
          return TaskTile(
            completed: widget.executableTasks[index].isDone,
            task: widget.tasks[index],
            onChecked: (value) {
              showCupertinoDialog<void>(
                context: context,
                builder:
                    (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Complete task'),
                      content: const Text(
                        "Please check this box only after you have genuinely completed the task. After this you won' t be able to uncheck it.",
                      ),
                      actions: <CupertinoDialogAction>[
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            setState(() {
                              // Complete task
                              widget.executableTasks[index].complete();
                              // Add xp to user
                              userData.incrementExperience(
                                widget.executableTasks[index].task.type,
                                widget.scheduledDay,
                                experience,
                              );
                              toastification.show(
                                context: context,
                                title: Text(
                                  '${widget.executableTasks[index].task.type.format()} task completed!',
                                ),
                                description: Text(
                                  '${experience.value}+ ${widget.executableTasks[index].task.type.format()} xp',
                                ),
                                type: ToastificationType.success,
                                autoCloseDuration: Duration(seconds: 3),
                              );
                            });
                            Navigator.pop(context);
                          },
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
              );
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
