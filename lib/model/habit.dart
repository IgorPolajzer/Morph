import 'package:uuid/uuid.dart';

import '../utils/enums.dart';

class Habit {
  final String id;

  final String title;
  final String description;
  final HabitType type;
  final bool notifications;

  Habit({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.notifications,
  }) : id = id ?? const Uuid().v4();

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    type: HabitType.getTypeFromString(json['type'] ?? ''),
    notifications: json['notifications'],
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'type': type.name.toLowerCase(),
    'description': description,
    'notifications': notifications,
    'id': id,
  };
}
