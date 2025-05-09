import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user.dart';
import '../../utils/enums.dart';
import '../tiles/habit_tile.dart';

class HabitList extends StatelessWidget {
  final HabitType type;

  HabitList({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (BuildContext context, userData, Widget? child) {
        var habits = userData.getHabitsFromType(type);

        return ListView.builder(
          shrinkWrap: true, // Makes it take only the space it needs
          physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
          itemBuilder: (context, index) {
            final task = habits?[index];

            if (task != null) {
              return HabitTile(
                habit: task.title,
                description: task.description,
              );
            }
          },
          itemCount: habits?.length,
        );
      },
    );
  }
}
