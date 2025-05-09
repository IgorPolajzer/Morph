import 'package:flutter/material.dart';
import 'package:morphe/screens/edit_task_screen.dart';
import 'package:morphe/utils/constants.dart';

import 'package:intl/intl.dart';

import '../utils/enums.dart';

enum Actions { edit, delete }

class TaskTile extends StatelessWidget {
  late DateTime startDateTime;
  late DateTime endDateTime;
  late String title;
  late String subtitle;
  late String description;
  late HabitType type;

  TaskTile({
    required this.startDateTime,
    required this.endDateTime,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    super.key,
  });

  Actions? selectedMenu;

  @override
  Widget build(BuildContext context) {
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
                  color: type.getColor(),
                  size: 18.0,
                ),
              ),
              title: Text(
                '${DateFormat.EEEE().format(startDateTime)}: ${DateFormat.Hm().format(startDateTime)}-${DateFormat.Hm().format(endDateTime)}',
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
                    TextSpan(text: '$title\n'),
                    WidgetSpan(child: SizedBox(height: 20)),
                    TextSpan(
                      text: '$subtitle',
                      style: kPlaceHolderTextStyle.copyWith(
                        fontSize: 12,
                        color: Theme.of(context).secondaryHeaderColor,
                      ), // <- your custom color here
                    ),
                  ],
                ),
              ),
              trailing: MenuAnchor(
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
                      if (Actions.values[index] == Actions.edit) {
                        /*Navigator.pushNamed(
                          context,
                          EditTaskScreen.id,
                          arguments: EditTaskScreenArguments(
                            title: title,
                            subtitle: subtitle,
                            description: description,
                            startDateTime: startDateTime,
                            endDateTime: endDateTime,
                            type: type,
                          ),
                        );*/
                      }
                    },
                    child: Text(
                      Actions.values[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
