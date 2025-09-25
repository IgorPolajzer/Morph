import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:go_router/go_router.dart';
import 'package:morphe/components/pop_ups/show_more_popup.dart';
import 'package:morphe/repositories/impl/habit_repository.dart';
import 'package:provider/provider.dart';

import '../../state/user_data.dart';
import '../../utils/enums.dart';
import '../tiles/habit_tile.dart';

class HabitList extends StatefulWidget {
  final HabitType? type;
  final modifiable;

  const HabitList({this.type, this.modifiable = false, super.key});

  @override
  State<HabitList> createState() => _HabitListState();
}

class _HabitListState extends State<HabitList> {
  // Repostories.
  final HabitRepository habitRepository = HabitRepository();

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context, listen: true);
    final router = GoRouter.of(context);
    var habits = userData.getHabitsFromType(widget.type);

    return ListView.builder(
      shrinkWrap: true, // Makes it take only the space it needs
      physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
      itemBuilder: (context, index) {
        final habit = habits?[index];

        if (habit != null) {
          return HabitTile(
            modifiable: widget.modifiable,
            habit: habit,
            onLongPress: () {
              showCupertinoDialog<void>(
                context: context,
                builder:
                    (BuildContext context) => CupertinoAlertDialog(
                      title: const Text('Confirm deletion'),
                      content: const Text(
                        'Are you sure you want to delete this habit?',
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
                          onPressed: () async {
                            userData.deleteHabit(habit);
                            await habitRepository.delete(
                              userData.userId,
                              habit.id,
                            );
                            router.pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
              );
            },
            onTapReadMore:
                () => showPopupCard(
                  context: context,
                  builder: (context) {
                    return ShowMorePopUp(
                      title: habit.title,
                      description: habit.description,
                    );
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
