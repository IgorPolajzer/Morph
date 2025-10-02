import 'package:hive/hive.dart';
import '../../model/habit.dart';
import '../../utils/enums.dart';

class HabitHiveRepository {
  final Box<Habit> habitBox;

  HabitHiveRepository(this.habitBox);

  /// Save or update a single habit
  Future<void> save(Habit habit) async {
    habit.dirty = true;
    await habitBox.put(habit.id, habit);
  }

  /// Soft delete a habit
  Future<void> delete(String habitId) async {
    final habit = habitBox.get(habitId);
    if (habit != null) {
      habit.dirty = true;
      habit.deleted = true;
      await habit.save();
    }
  }

  /// Update habit using copyWith
  Future<void> update(
    String habitId, {
    String? title,
    String? description,
    HabitType? type,
    bool? notifications,
  }) async {
    final existingHabit = habitBox.get(habitId);
    if (existingHabit != null) {
      final updatedHabit = existingHabit.copyWith(
        title: title,
        description: description,
        type: type,
        notifications: notifications,
      );
      updatedHabit.dirty = true;
      await habitBox.put(habitId, updatedHabit);
    }
  }

  /// Fetch all non-deleted habits
  Future<List<Habit>> fetchAll() async {
    return habitBox.values.where((h) => h.deleted != true).toList();
  }

  /// Save multiple habits at once
  Future<void> saveAll(List<Habit> habits) async {
    final Map<String, Habit> map = {};
    for (var habit in habits) {
      habit.dirty = true;
      map[habit.id] = habit;
    }
    await habitBox.putAll(map);
  }

  /// Replace all habits in Hive
  Future<void> overrideAll(List<Habit> newHabits) async {
    await habitBox.clear();
    await saveAll(newHabits);
  }

  /// Get habits marked as dirty
  Future<List<Habit>> getDirtyHabits() async {
    return habitBox.values.where((h) => h.dirty == true).toList();
  }
}
