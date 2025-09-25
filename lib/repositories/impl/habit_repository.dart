import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/habit.dart';
import '../firestore_repository.dart';

class HabitRepository implements FirestoreRepository<Habit> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> save(String userId, Habit item) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(item.id)
          .set(item.toMap());
      // set because we provide our own id.
    } catch (e) {
      print('Error saving habit: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String userId, String itemId) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(itemId)
          .delete();
    } catch (e) {
      print('Error deleting habit: $e');
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
          .collection('habits')
          .doc(itemId)
          .set(updatedFields, SetOptions(merge: true));
      // Updates object even if not all fields are provided (doesn't override unprovided fields).
    } catch (e) {
      print('Error updating habit: $e');
      rethrow;
    }
  }

  @override
  Future<List<Habit>> fetchAll(String userId) async {
    try {
      final snapshot =
          await firestore
              .collection('users')
              .doc(userId)
              .collection('habits')
              .get();

      return snapshot.docs.map((doc) => Habit.fromJson(doc.data())).toList();
    } catch (e) {
      print('Error fetching habits: $e');
      return [];
    }
  }

  @override
  Future<void> saveAll(String userId, List<Habit>? items) async {
    if (items == null || items.isEmpty) return;

    final batch = firestore.batch();
    final habitsRef = firestore
        .collection('users')
        .doc(userId)
        .collection('habits');

    for (final habit in items) {
      final docRef = habitsRef.doc(habit.id);
      batch.set(docRef, habit.toMap());
    }

    try {
      await batch.commit();
    } catch (e) {
      print('Error batch saving habits: $e');
      rethrow;
    }
  }

  @override
  Future<void> overrideAll(String userId, List<Habit> newItems) async {
    final habitsCollection = firestore
        .collection('users')
        .doc(userId)
        .collection('habits');

    try {
      final snapshot = await habitsCollection.get();
      final batch = firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      final batchSave = firestore.batch();
      for (var habit in newItems) {
        final docRef = habitsCollection.doc(habit.id);
        batchSave.set(docRef, habit.toMap());
      }
      await batchSave.commit();
    } catch (e) {
      print('Error overriding all habits: $e');
      rethrow;
    }
  }
}
