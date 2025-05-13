import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../utils/enums.dart';

class Habit {
  String title;
  String description;
  HabitType type;
  String id = Uuid().v4();

  Habit({required this.title, required this.description, required this.type});

  factory Habit.fromJson(Map<String, dynamic> json) {
    var habit = Habit(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: HabitType.getTypeFromString(json['type'] ?? ''),
    );
    habit.id = json['id'];

    return habit;
  }

  static Future<List<Habit>> pullFromFirebase(String id) async {
    try {
      final habitDocs =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .collection('habits')
              .get();

      return habitDocs.docs.map((doc) => Habit.fromJson(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'type': type.name.toLowerCase(),
      'description': description,
      'id': id,
    };
  }
}
