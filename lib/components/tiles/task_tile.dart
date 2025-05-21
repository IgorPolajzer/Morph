import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/utils/constants.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../model/task.dart';
import '../../model/user_data.dart';
import '../pop_ups/edit_task_popup.dart';

enum MenuActions { edit, delete }

class TaskTile extends StatelessWidget {
  Task task;

  final GestureTapCallback? onTap;
  final ValueChanged<bool?>? onChecked;

  bool modifiable;
  bool completed;
  bool executable;

  TaskTile({
    required this.onTap,
    required this.task,
    this.modifiable = false,
    this.completed = false,
    this.executable = true,
    this.onChecked,
    super.key,
  });

  MenuActions? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: true);

    Widget? getTrailing() {
      if (modifiable) {
        MenuAnchor(
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return IconButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: Icon(
                Icons.more_horiz,
                color: Theme.of(context).primaryColor,
              ),
              tooltip: 'Show menu',
            );
          },
          menuChildren: List<MenuItemButton>.generate(
            2,
            (int index) => MenuItemButton(
              onPressed: () {
                if (MenuActions.values[index] == MenuActions.edit) {
                  showPopupCard(
                    context: context,
                    builder: (context) {
                      return EditTaskPopUp(task: task);
                    },
                    alignment: Alignment.bottomCenter,
                    useSafeArea: true,
                    dimBackground: true,
                  );
                } else if (MenuActions.values[index] == MenuActions.delete) {
                  showCupertinoDialog<void>(
                    context: context,
                    builder:
                        (BuildContext context) => CupertinoAlertDialog(
                          title: const Text('Confirm deletion'),
                          content: const Text(
                            'Are you sure you want to remove this task?',
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
                                user.deleteTask(task);
                                Navigator.pop(context);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                  );
                }
              },
              child: Text(
                MenuActions.values[index].name,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        );
      } else if (executable) {
        return Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Checkbox(value: completed, onChanged: onChecked),
        );
      }

      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Card(
        color: Theme.of(context).cardColor,
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity(vertical: 3.0),
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(
                  Icons.circle_rounded,
                  color:
                      executable
                          ? task.type.getColor()
                          : task.type.getColor().withAlpha(75),
                  size: 18.0,
                ),
              ),
              title: Text(
                '${task.scheduledDay.name}: ${DateFormat.Hm().format(task.startDateTime)}-${DateFormat.Hm().format(task.endDateTime)}',
                style: TextStyle(
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
              titleTextStyle: kTitleTextStyle.copyWith(
                color:
                    executable
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withAlpha(75),
                fontSize: 12,
              ),
              subtitle: GestureDetector(
                onTap: onTap,
                child: RichText(
                  text: TextSpan(
                    style: kTitleTextStyle.copyWith(
                      fontSize: 16,
                      color:
                          executable
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColor.withAlpha(75),
                    ),
                    children: [
                      TextSpan(
                        text: '${task.title}\n',
                        style: TextStyle(
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      WidgetSpan(child: SizedBox(height: 20)),
                      TextSpan(
                        text: '${task.subtitle}',
                        style: kPlaceHolderTextStyle.copyWith(
                          fontSize: 12,
                          color:
                              executable
                                  ? Theme.of(context).secondaryHeaderColor
                                  : Theme.of(
                                    context,
                                  ).secondaryHeaderColor.withAlpha(75),
                          decoration:
                              completed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              trailing: getTrailing(),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
