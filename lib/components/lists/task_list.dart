import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/tiles/task_tile.dart';
import 'package:provider/provider.dart';

import '../../state/user_data.dart';
import '../../utils/enums.dart';
import '../pop_ups/show_more_popup.dart';

class TasksList extends StatelessWidget {
  final HabitType type;

  TasksList({required this.type});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: true);
    var tasks = user.getTasksFromType(type);

    return ListView.builder(
      shrinkWrap: true, // Makes it take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      itemBuilder: (context, index) {
        final task = tasks?[index];

        if (task != null) {
          return TaskTile(
            modifiable: true,
            task: task,
            onTap:
                () => showPopupCard(
                  context: context,
                  builder: (context) {
                    return ShowMorePopUp(
                      title: task.title,
                      description: task.description,
                      subtitle: task.subtitle,
                    );
                  },
                  alignment: Alignment.center,
                  useSafeArea: true,
                  dimBackground: true,
                ),
          );
        }
        return null;
      },
      itemCount: tasks?.length,
    );
  }
}
