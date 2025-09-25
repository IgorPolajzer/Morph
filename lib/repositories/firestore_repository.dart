/// Generic interface for Firestore repositories handling items of type [T] per user.
abstract class FirestoreRepository<T> {
  /// Save a single item for a user.
  Future<void> save(String userId, T item);

  /// Delete an item by ID for a user.
  Future<void> delete(String userId, String itemId);

  /// Update specific fields of an item by ID for a user.
  Future<void> update(
    String userId,
    String itemId,
    Map<String, dynamic> updatedFields,
  );

  /// Fetch all items for a user.
  Future<List<T>> fetchAll(String userId);

  /// Save multiple items for a user in a batch.
  Future<void> saveAll(String userId, List<T> items);

  /// Replaces all existing tasks with the provided list of tasks.
  /// Deletes any tasks not in the new list.
  Future<void> overrideAll(String userId, List<T> newItems);
}
