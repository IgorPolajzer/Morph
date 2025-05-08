import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/habit_data.dart';
import 'habit_tile.dart';

class HabitList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HabitData>(
      builder: (BuildContext context, habitData, Widget? child) {
        return ListView.builder(
          shrinkWrap: true, // Makes it take only the space it needs
          physics: NeverScrollableScrollPhysics(), // Disable inner scrolling
          itemBuilder: (context, index) {
            final task = habitData.tasks[index];
            return HabitTile(habit: task.title, description: task.description);
          },
          itemCount: habitData.taskCount,
        );
      },
    );
  }
}
