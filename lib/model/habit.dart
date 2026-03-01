import 'package:uuid/uuid.dart';
import '../../utils/enums.dart';

class Habit {
  final String id;

  final String title;

  final String description;

  final HabitType type;

  final bool notifications;

  bool dirty = false;

  bool deleted = false;

  Habit({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.notifications,
  }) : id = id ?? const Uuid().v4();

  Habit copyWith({
    String? title,
    String? description,
    HabitType? type,
    bool? notifications,
  }) {
    return Habit(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        type: type ?? this.type,
        notifications: notifications ?? this.notifications,
      )
      ..dirty = dirty
      ..deleted = deleted;
  }

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    id: json['id'],
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    type: HabitType.getTypeFromString(json['type'] ?? ''),
    notifications: json['notifications'] ?? false,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'type': type.name.toLowerCase(),
    'description': description,
    'notifications': notifications,
    'id': id,
  };
}
