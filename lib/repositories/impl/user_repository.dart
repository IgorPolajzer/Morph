import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/experience.dart';
import '../../model/user_model.dart';
import '../../utils/enums.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Fetch full user data as User model
  Future<UserModel?> fetchUser(String? userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  /// Save or overwrite entire user document
  Future<void> saveUser(String userId, UserModel user) async {
    try {
      await firestore.collection('users').doc(userId).set(user.toMap());
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }

  /// Patch specific fields in user document
  Future<void> updateUser(
    String userId,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .set(updatedFields, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Delete entire user document.
  Future<void> deleteUser(String userId) async {
    try {
      await firestore.collection('users').doc(userId).delete();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Update experience map for all HabitTypes
  Future<void> updateExperience(
    String userId,
    Map<HabitType, Experience> experience,
  ) async {
    final expMap = experience.map(
      (k, v) => MapEntry(k.name.toLowerCase(), v.toMap()),
    );
    try {
      await firestore.collection('users').doc(userId).set({
        'experience': expMap,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating experience: $e');
      rethrow;
    }
  }

  /// Add a taskId to completedTasks array
  Future<void> addCompletedTask(String userId, String taskId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'completedTasks': FieldValue.arrayUnion([taskId]),
      });
    } catch (e) {
      print('Error adding completed task: $e');
      rethrow;
    }
  }

  /// Remove a taskId from completedTasks array
  Future<void> removeCompletedTask(String userId, String taskId) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'completedTasks': FieldValue.arrayRemove([taskId]),
      });
    } catch (e) {
      print('Error removing completed task: $e');
      rethrow;
    }
  }

  /// Retrieve all completed task IDs for a given user
  Future<List<String>> getCompletedTasks(String userId) async {
    try {
      final doc = await firestore.collection('users').doc(userId).get();

      if (!doc.exists) return [];

      final data = doc.data();
      if (data == null || data['completedTasks'] == null) return [];

      // Ensure type-safety by casting to List<String>
      final List<dynamic> tasks = data['completedTasks'];
      return tasks.cast<String>();
    } catch (e) {
      print('Error fetching completed tasks: $e');
      return [];
    }
  }
}
