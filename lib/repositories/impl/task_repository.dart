import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/task.dart';
import '../firestore_repository.dart';

class TaskRepository implements FirestoreRepository<Task> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> save(String userId, Task item) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(item.id)
          .set(item.toMap());
      // set because we provide our own id.
    } catch (e) {
      print('Error saving task: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String userId, String itemId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(itemId)
          .delete();
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(
    String userId,
    String itemId,
    Map<String, dynamic> updatedFields,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('tasks')
          .doc(itemId)
          .set(updatedFields, SetOptions(merge: true));
      // Updates object even if not all fields are provided (doesn't override unprovided fields).
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
    ;
  }

  @override
  Future<List<Task>> fetchAll(String userId) async {
    try {
      final snapshot =
          await firestore
              .collection('users')
              .doc(userId)
              .collection('tasks')
              .get();

      return snapshot.docs.map((task) => Task.fromJson(task.data())).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Replaces existing Tasks with matching IDs and adds new ones for new IDs.
  @override
  Future<void> saveAll(String userId, List<Task>? items) async {
    if (items == null || items.isEmpty) return;

    final batch = firestore.batch();
    final tasksRef = firestore
        .collection('users')
        .doc(userId)
        .collection('tasks');

    for (final task in items) {
      final docRef = tasksRef.doc(task.id);
      batch.set(docRef, task.toMap());
    }

    try {
      await batch.commit();
    } catch (e) {
      print('Error batch saving tasks: $e');
      rethrow;
    }
  }

  @override
  Future<void> overrideAll(String userId, List<Task> newItems) async {
    final tasksCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('tasks');

    try {
      final snapshot = await tasksCollection.get();
      final batch = firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      final batchSave = firestore.batch();
      for (var task in newItems) {
        final docRef = tasksCollection.doc(task.id);
        batchSave.set(docRef, task.toMap());
      }
      await batchSave.commit();
    } catch (e) {
      print('Error overriding all tasks: $e');
      rethrow;
    }
  }
}
