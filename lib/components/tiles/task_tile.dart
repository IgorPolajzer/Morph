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
  bool modifiable;
  final GestureTapCallback? onTap;

  TaskTile({
    required this.task,
    required this.onTap,
    this.modifiable = true,
    super.key,
  });

  MenuActions? selectedMenu;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context, listen: true);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
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
                    color: task.type.getColor(),
                    size: 18.0,
                  ),
                ),
                title: Text(
                  '${task.scheduledDay.name}: ${DateFormat.Hm().format(task.startDateTime)}-${DateFormat.Hm().format(task.endDateTime)}',
                ),
                titleTextStyle: kTitleTextStyle.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 12,
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: kTitleTextStyle.copyWith(
                      fontSize: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    children: [
                      TextSpan(text: '${task.title}\n'),
                      WidgetSpan(child: SizedBox(height: 20)),
                      TextSpan(
                        text: '${task.subtitle}',
                        style: kPlaceHolderTextStyle.copyWith(
                          fontSize: 12,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing:
                    modifiable
                        ? MenuAnchor(
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
                                if (MenuActions.values[index] ==
                                    MenuActions.edit) {
                                  showPopupCard(
                                    context: context,
                                    builder: (context) {
                                      return EditTaskPopUp(task: task);
                                    },
                                    alignment: Alignment.bottomCenter,
                                    useSafeArea: true,
                                    dimBackground: true,
                                  );
                                } else if (MenuActions.values[index] ==
                                    MenuActions.delete) {
                                  showCupertinoDialog<void>(
                                    context: context,
                                    builder:
                                        (
                                          BuildContext context,
                                        ) => CupertinoAlertDialog(
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
                        )
                        : null,
                isThreeLine: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
