import 'package:hive/hive.dart';
import '../../model/user_model.dart';
import '../../model/experience.dart';
import '../../utils/enums.dart';

class UserHiveRepository {
  final Box<UserModel> userBox;

  UserHiveRepository(this.userBox);

  /// Fetch a user
  Future<UserModel?> fetchUser(String userId) async {
    return userBox.get(userId);
  }

  /// Save or overwrite entire user
  Future<void> saveUser(UserModel user) async {
    user.dirty = true;
    await userBox.put(user.email, user); // Use email or id as key
  }

  /// Update specific fields using copyWith
  Future<void> updateUser(
    String userId, {
    String? email,
    String? username,
    Map<HabitType, Experience>? experience,
    Map<HabitType, bool>? selectedHabits,
    List<String>? completedTasks,
  }) async {
    final user = userBox.get(userId);
    if (user != null) {
      final updatedUser = user.copyWith(
        email: email,
        username: username,
        experience: experience,
        selectedHabits: selectedHabits,
        completedTasks: completedTasks,
        dirty: true,
      );
      await userBox.put(userId, updatedUser);
    }
  }

  /// Delete user (soft delete)
  Future<void> deleteUser(String userId) async {
    final user = userBox.get(userId);
    if (user != null) {
      user.deleted = true;
      user.dirty = true;
      await user.save();
    }
  }

  /// Update experience map for all HabitTypes
  Future<void> updateExperience(
    String userId,
    Map<HabitType, Experience> experience,
  ) async {
    final user = userBox.get(userId);
    if (user != null) {
      final updatedUser = user.copyWith(experience: experience, dirty: true);
      await userBox.put(userId, updatedUser);
    }
  }

  /// Add a completed task
  Future<void> addCompletedTask(String userId, String taskId) async {
    final user = userBox.get(userId);
    if (user != null && !user.completedTasks.contains(taskId)) {
      final updatedUser = user.copyWith(
        completedTasks: [...user.completedTasks, taskId],
        dirty: true,
      );
      await userBox.put(userId, updatedUser);
    }
  }

  /// Remove a completed task
  Future<void> removeCompletedTask(String userId, String taskId) async {
    final user = userBox.get(userId);
    if (user != null && user.completedTasks.contains(taskId)) {
      final updatedUser = user.copyWith(
        completedTasks: user.completedTasks.where((t) => t != taskId).toList(),
        dirty: true,
      );
      await userBox.put(userId, updatedUser);
    }
  }

  /// Retrieve all dirty users for syncing
  Future<List<UserModel>> getDirtyUsers() async {
    return userBox.values.where((u) => u.dirty == true).toList();
  }
}
