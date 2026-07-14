//VaultRepository we use to fetchc the valut from our sqlite database

import 'package:drift/drift.dart';

import '../database/app_database.dart';

//this is to do operation on valut, valut will talk with db
class VaultRepository {
  final AppDatabase database;

  VaultRepository(this.database);

  //get all item form dababase
  Future<List<VaultItem>> getAllItems(String userId) {
    return database.getVaultItemsByUser(userId);
  }

  //add item , but before add compare it first , if it have in DB or not
  Future<int> addItem({
    required String userId,
    required String title,
    required String category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    //take now as the create at
    final now = DateTime.now();

    //compare it
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

  //update item

  Future<bool> updateItem({
    required VaultItem oldItem,
    required String title,
    required String category,
    required String secretValue,
    required String description,
    required bool isFavorite,
  }) {
    //update it , copy with will change only update paramaneter
    final updatedItem = oldItem.copyWith(
      title: title,
      category: category,
      secretValue: secretValue,
      description: description,
      isFavorite: isFavorite,
      updatedAt: DateTime.now(),
    );
    //give db to update
    return database.updateVaultItem(updatedItem);
  }

  //delete by ID
  Future<int> deleteItem(int id) {
    return database.deleteVaultItem(id);
  }

  //we can search our item with keyword
  Future<List<VaultItem>> searchItems({
    required String userId,
    required String keyword,
  }) {
    return database.searchVaultItems(userId: userId, keyword: keyword);
  }

  //can sort category likw password,note or...
  Future<List<VaultItem>> getItemsByCategory({
    required String userId,
    required String category,
  }) {
    return database.getVaultItemsByCategory(userId: userId, category: category);
  }
}
