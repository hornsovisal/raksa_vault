// VaultRepository we use to fetch the vault from our sqlite database
import 'package:drift/drift.dart';
import 'package:raksa_vault/models/record_category.dart';

import '../database/app_database.dart';

// this is to do operation on vault, vault will talk with db
class VaultRepository {
  final AppDatabase database;

  VaultRepository(this.database);

  // get all item from database
  Future<List<VaultItem>> getAllItems(String userId) {
    return database.getVaultItemsByUser(userId);
  }

  // add item to database
  Future<int> addItem({
    required String userId,
    required String title,
    required RecordCategory category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    // take current time as create time
    final now = DateTime.now();

    final item = VaultItemsCompanion(
      userId: Value(userId),
      title: Value(title),

      // enum change to string before save in sqlite
      category: Value(category.dbValue),

      secretValue: Value(secretValue),
      description: Value(description),
      isFavorite: Value(isFavorite),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return database.insertVaultItem(item);
  }

  // update item
  Future<bool> updateItem({
    required VaultItem oldItem,
    required String title,
    required RecordCategory category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    // copy old item and change only new values
    final updatedItem = oldItem.copyWith(
      title: title,

      // enum change to string before save
      category: category.dbValue,

      secretValue: secretValue,
      description: description,
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );

    return database.updateVaultItem(updatedItem);
  }

  // delete item by id
  Future<int> deleteItem(int id) {
    return database.deleteVaultItem(id);
  }

  // search item with keyword
  Future<List<VaultItem>> searchItems({
    required String userId,
    required String keyword,
  }) {
    return database.searchVaultItems(userId: userId, keyword: keyword);
  }

  // get item by category
  Future<List<VaultItem>> getItemsByCategory({
    required String userId,
    required RecordCategory category,
  }) {
    return database.getVaultItemsByCategory(
      userId: userId,

      // sqlite still receives string value
      category: category.dbValue,
    );
  }
}
