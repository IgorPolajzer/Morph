/// Repository for local storage.
abstract class HiveRepository<T> {
  /// Save a single item locally.
  Future<void> save(T item);

  /// Delete an item by ID locally.
  Future<void> delete(String itemId);

  /// Update specific fields of an item locally.
  Future<void> update(String itemId, Map<String, dynamic> updatedFields);

  /// Fetch all items from Hive.
  Future<List<T>> fetchAll();

  /// Save multiple items at once.
  Future<void> saveAll(List<T> items);

  /// Replace all items in Hive with a new list.
  Future<void> overrideAll(List<T> newItems);

  /// Optional: get items marked as dirty for syncing.
  Future<List<T>> getDirtyItems();
}
