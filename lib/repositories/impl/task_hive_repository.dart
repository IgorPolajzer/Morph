import 'package:hive/hive.dart';
import '../../model/task.dart';

class TaskHiveRepository {
  final Box<Task> taskBox;

  TaskHiveRepository(this.taskBox);

  /// Save or update a single task
  Future<void> save(Task task) async {
    task.dirty = true; // mark for sync
    await taskBox.put(task.id, task);
  }

  /// Delete a task (soft delete for offline sync)
  Future<void> delete(String taskId) async {
    final task = taskBox.get(taskId);
    if (task != null) {
      task.dirty = true;
      task.deleted = true;
      await task.save(); // persist changes
    }
  }

  /// Update specific fields on an existing task
  Future<void> update(
    String taskId, {
    String? title,
    String? subtitle,
    String? description,
    bool? notifications,
  }) async {
    final existingTask = taskBox.get(taskId);
    if (existingTask != null) {
      // Create a new Task instance with updated fields
      final updatedTask = existingTask.copyWith(
        title: title,
        subtitle: subtitle,
        description: description,
        notifications: notifications,
      );

      // Mark as dirty for offline sync
      updatedTask.dirty = true;

      // Save back to Hive
      await taskBox.put(taskId, updatedTask);
    }
  }

  /// Fetch all tasks that are not deleted
  Future<List<Task>> fetchAll() async {
    return taskBox.values.where((t) => t.deleted != true).toList();
  }

  /// Save multiple tasks at once
  Future<void> saveAll(List<Task>? tasks) async {
    if (tasks == null || tasks.isEmpty) return;

    final Map<String, Task> itemsMap = {};
    for (var task in tasks) {
      task.dirty = true;
      itemsMap[task.id] = task;
    }
    await taskBox.putAll(itemsMap);
  }

  /// Replace all tasks in Hive with a new list
  Future<void> overrideAll(List<Task> newTasks) async {
    await taskBox.clear();
    await saveAll(newTasks);
  }

  /// Get tasks marked as dirty for syncing
  Future<List<Task>> getDirtyTasks() async {
    return taskBox.values.where((t) => t.dirty == true).toList();
  }
}
