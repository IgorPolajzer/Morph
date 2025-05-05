import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import 'package:intl/intl.dart';

import '../utils/enums.dart';

class TaskTile extends StatelessWidget {
  late DateTime startTime;
  late DateTime endTime;
  late String title;
  late String subtitle;
  late TaskType type;

  TaskTile({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.subtitle,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Card(
        color: Theme.of(context).extension<CustomColors>()!.taskTileColor,
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
                '${DateFormat.Hm().format(startTime)}-${DateFormat.Hm().format(endTime)}',
              ),
              titleTextStyle: kTitleTextStyle.copyWith(
                color: Theme.of(context).extension<CustomColors>()!.headerColor,
                fontSize: 12,
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: kTitleTextStyle.copyWith(
                    fontSize: 16,
                    color:
                        Theme.of(
                          context,
                        ).extension<CustomColors>()!.headerColor,
                  ),
                  children: [
                    TextSpan(text: '$title\n'),
                    WidgetSpan(child: SizedBox(height: 20)),
                    TextSpan(
                      text: '$subtitle',
                      style: kPlaceHolderTextStyle.copyWith(
                        fontSize: 12,
                        color:
                            Theme.of(
                              context,
                            ).extension<CustomColors>()!.placeholderTextColor,
                      ), // <- your custom color here
                    ),
                  ],
                ),
              ),
              trailing: Icon(
                Icons.more_vert,
                color: Theme.of(context).extension<CustomColors>()!.headerColor,
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
