import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/tiles/task_tile.dart';

import '../../model/task.dart';
import '../pop_ups/show_more_popup.dart';

class DailyTasksList extends StatelessWidget {
  final List<Task> tasks;

  const DailyTasksList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return TaskTile(
          modifiable: false,
          task: tasks[index],
          onTap:
              () => showPopupCard(
                context: context,
                builder: (context) {
                  return ShowMorePopUp(
                    title: tasks[index].title,
                    description: tasks[index].description,
                    subtitle: tasks[index].subtitle,
                  );
                },
                alignment: Alignment.center,
                useSafeArea: true,
                dimBackground: true,
              ),
        );
      },
    );
  }
}
