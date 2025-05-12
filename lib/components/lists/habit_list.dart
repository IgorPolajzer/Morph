import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:morphe/components/pop_ups/read_more_habit_popup.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../utils/enums.dart';
import '../tiles/habit_tile.dart';

class HabitList extends StatefulWidget {
  final HabitType type;

  HabitList({required this.type, super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: true);
    var habits = user.getHabitsFromType(widget.type);

    return ListView.builder(
      shrinkWrap: true, // Makes it take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      itemBuilder: (context, index) {
        final habit = habits?[index];

        if (habit != null) {
          return HabitTile(
            habit: habit,
            onLongPress: () {
              print("longpress");
              user.deleteHabit(habit);
            },
            onTapReadMore:
                () => showPopupCard(
                  context: context,
                  builder: (context) {
                    return ReadMoreHabitPopUp(habit: habit);
                  },
                  alignment: Alignment.center,
                  useSafeArea: true,
                  dimBackground: true,
                ),
          );
        }
      },
      itemCount: habits?.length,
    );
  }
}
