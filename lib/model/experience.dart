import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../utils/enums.dart';
import '../utils/functions.dart';

class Experience {
  static int _increment = 20;

  int points;
  int maxXp;
  int level;

  Experience({this.points = 0, this.maxXp = 100, this.level = 1});

  factory Experience.fromJson(Map<String, dynamic> json) {
    var habit = Experience(
      points: json['points'] ?? 0,
      level: json['level'] ?? 1,
    );

    return habit;
  }

  Map<String, dynamic> toMap() {
    return {'level': level, 'points': points};
  }

  static int getMetaXp(Map<HabitType, Experience> experiences) {
    int metaXp = 0;

    for (HabitType type in HabitType.values) {
      int xp = 0;
      Experience experience = experiences[type]!;

      if (experience.level > 1) {
        xp += 100 * (experience.level - 1);
        xp += experience.points;
      } else {
        xp += experience.points;
      }

      metaXp += xp;
    }

    return metaXp;
  }

  static int getMetaMaxXp(Map<HabitType, Experience> experiences) {
    int maxXp = 0;

    for (HabitType type in HabitType.values) {
      maxXp += experiences[type]!.maxXp;
    }

    return maxXp;
  }

  void increment(DateTime scheduledDate, ValueNotifier<int> experience) {
    experience.value =
        isToday(scheduledDate) != scheduledDate.isBefore(DateTime.now())
            ? (_increment / 2).round()
            : _increment;

    if ((points + experience.value) >= maxXp) {
      points = (points + experience.value) % maxXp;
      level++;
    } else {
      points += experience.value;
    }
  }

  // Firebase interaction
  Future<bool> pushToFirebase(HabitType type) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(getUserFirebaseId())
          .set({
            'experience': {type.name.toLowerCase(): toMap()},
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Failed to push experience to Firebase: $e');
      return false;
    }
  }
}
