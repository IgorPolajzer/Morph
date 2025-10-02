import 'package:uuid/uuid.dart';
import '../../utils/enums.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final HabitType type;

  @HiveField(4)
  final bool notifications;

  @HiveField(5)
  bool dirty = false;

  @HiveField(6)
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
