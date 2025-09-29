import 'package:flutter/cupertino.dart';

import '../utils/enums.dart';
import '../utils/functions.dart';

class Experience {
  final int points;
  final int maxXp;
  final int level;

  static const int defaultIncrement = 20;

  const Experience({this.points = 0, this.maxXp = 100, this.level = 1});

  /// Creates a copy of this [Experience] with optional field overrides.
  Experience copyWith({int? points, int? maxXp, int? level}) {
    return Experience(
      points: points ?? this.points,
      maxXp: maxXp ?? this.maxXp,
      level: level ?? this.level,
    );
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      points: json['points'] ?? 0,
      maxXp: json['maxXp'] ?? 100,
      level: json['level'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {'points': points, 'maxXp': maxXp, 'level': level};
  }

  /// Returns a new [Experience] after applying XP increment.
  Experience increment(DateTime scheduledDate, ValueNotifier<int> increment) {
    final bool isToday = isSameDay(scheduledDate, DateTime.now());
    increment.value = isToday ? increment.value : (increment.value / 2).round();

    int newPoints = points + increment.value;
    int newLevel = level;

    if (newPoints >= maxXp) {
      newPoints = newPoints % maxXp;
      newLevel++;
    }

    return copyWith(points: newPoints, level: newLevel);
  }

  /// Computes meta XP across all [Experience]s.
  static int getMetaXp(Map<HabitType, Experience> experiences) {
    int metaXp = 0;

    for (final type in HabitType.values) {
      final exp = experiences[type]!;
      metaXp += ((exp.level - 1) * exp.maxXp) + exp.points;
    }

    return metaXp;
  }

  /// Computes meta max XP across all [Experience]s.
  static int getMetaMaxXp(Map<HabitType, Experience> experiences) {
    return experiences.values.fold(0, (sum, exp) => sum + exp.maxXp);
  }
}
