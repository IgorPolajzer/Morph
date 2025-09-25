import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../utils/enums.dart';
import '../utils/functions.dart';

class Task {
  final String id;

  final String title;
  final String subtitle;
  final String description;
  final Frequency scheduledFrequency;
  final Day scheduledDay;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final HabitType type;
  final bool notifications;

  Task({
    String? id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.scheduledFrequency,
    required this.scheduledDay,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required this.type,
    required this.notifications,
    bool normalize = true, // Normalize DateTime timestamps to today.
  }) : id = id ?? const Uuid().v4(),
       startDateTime = normalize ? normalizeTime(startDateTime) : startDateTime,
       endDateTime = normalize ? normalizeTime(endDateTime) : endDateTime;

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    Frequency? scheduledFrequency,
    Day? scheduledDay,
    DateTime? startDateTime,
    DateTime? endDateTime,
    HabitType? type,
    bool? notifications,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      scheduledFrequency: scheduledFrequency ?? this.scheduledFrequency,
      scheduledDay: scheduledDay ?? this.scheduledDay,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      type: type ?? this.type,
      notifications: notifications ?? this.notifications,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] ?? const Uuid().v4(),
    title: json['title'] ?? '',
    subtitle: json['subtitle'] ?? '',
    description: json['description'] ?? '',
    scheduledFrequency: Frequency.getFrequencyFromString(
      json['scheduledFrequency'] ?? '',
    ),
    scheduledDay: Day.getDayFromString(json['scheduledDay'] ?? ''),
    startDateTime:
        (json['startDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    endDateTime:
        (json['endDateTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
    type: HabitType.getTypeFromString(json['type'] ?? ''),
    notifications: json['notifications'] ?? false,
    normalize: false,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'title': title,
    'subtitle': subtitle,
    'description': description,
    'scheduledFrequency': scheduledFrequency.name.toLowerCase(),
    'scheduledDay': scheduledDay.name.toLowerCase(),
    'startDateTime': Timestamp.fromDate(startDateTime),
    'endDateTime': Timestamp.fromDate(endDateTime),
    'type': type.name.toLowerCase(),
    'notifications': notifications,
    'id': id,
  };
}
