import 'package:flutter/material.dart';
import 'package:morphe/utils/constants.dart';

import '../../model/habit.dart';

enum Actions { edit, delete }

class HabitTile extends StatelessWidget {
  Habit habit;
  final GestureTapCallback? onLongPress;
  final GestureTapCallback? onTapReadMore;

  HabitTile({
    required this.habit,
    required this.onLongPress,
    required this.onTapReadMore,
    super.key,
  });

  Actions? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: GestureDetector(
        onLongPress: onLongPress,
        child: Card(
          shape: StadiumBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
          ),
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  habit.title,
                  style: kTitleTextStyle.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                  ),
                ),
                GestureDetector(
                  onTap: onTapReadMore,
                  child: Text(
                    "Read more",
                    style: kTitleTextStyle.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
