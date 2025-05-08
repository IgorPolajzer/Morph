import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/enums.dart';
import 'habit.dart';

class HabitData extends ChangeNotifier {
  final List<Habit> _habits = [
    /*    Habit(
      title: "15000 daily steps",
      description: "Walk",
      type: TaskType.PHYSICAL,
    ),
    Habit(
      title: "Eat healthy",
      description: "Eat vegetables and unprocessed foods",
      type: TaskType.PHYSICAL,
    ),
    Habit(
      title: "Prioritise sleep",
      description:
          "Go to sleep and wake up at the same time every day and get 7-9 hours of sleep",
      type: TaskType.PHYSICAL,
    ),*/
  ];

  void parseHabitsFromFireBase() async {
    final firestore = FirebaseFirestore.instance;
    final habits = await firestore.collection("habits").get();

    for (var habit in habits.docs) {
      try {
        addHabit(
          habit['title'],
          habit['description'],
          HabitType.getTypeFromString(habit['type']),
        );
      } catch (e) {
        print("Exception parsing habit: ${e}");
      }
    }
    notifyListeners();
  }

  UnmodifiableListView<Habit> get tasks => UnmodifiableListView(_habits);
  int get taskCount => tasks.length;

  void addHabit(String title, String description, HabitType type) {
    _habits.add(Habit(title: title, description: description, type: type));
    notifyListeners();
  }

  void deletePhysicalTask(Habit habit) {
    _habits.remove(habit);
    notifyListeners();
  }
}
