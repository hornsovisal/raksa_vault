import 'package:drift/drift.dart';

import '../database/app_database.dart';

class VaultRepository {
  final AppDatabase database;

  VaultRepository(this.database);

  Future<List<VaultItem>> getAllItems(String userId) {
    return database.getVaultItemsByUser(userId);
  }

  Future<int> addItem({
    required String userId,
    required String title,
    required String category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    final now = DateTime.now();

    final item = VaultItemsCompanion(
      userId: Value(userId),
      title: Value(title),
      category: Value(category),
      secretValue: Value(secretValue),
      description: Value(description),
      isFavorite: Value(isFavorite),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return database.insertVaultItem(item);
  }

  Future<bool> updateItem({
    required VaultItem oldItem,
    required String title,
    required String category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    final updatedItem = oldItem.copyWith(
      title: title,
      category: category,
      secretValue: secretValue,
      description: description,
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );

    return database.updateVaultItem(updatedItem);
  }

  Future<int> deleteItem(int id) {
    return database.deleteVaultItem(id);
  }

  Future<List<VaultItem>> searchItems({
    required String userId,
    required String keyword,
  }) {
    return database.searchVaultItems(userId: userId, keyword: keyword);
  }

  Future<List<VaultItem>> getItemsByCategory({
    required String userId,
    required String category,
  }) {
    return database.getVaultItemsByCategory(userId: userId, category: category);
  }
}
