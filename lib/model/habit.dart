import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';

class Habit {
  String title;
  String description;
  HabitType type;

  Habit({required this.title, required this.description, required this.type});

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: HabitType.getTypeFromString(json['type'] ?? ''),
    );
  }

  static Future<List<Habit>> getHabitsFromFirebase(String id) async {
    final habitDocs =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .collection('habits')
            .get();

    return habitDocs.docs.map((doc) => Habit.fromJson(doc.data())).toList();
  }
}
