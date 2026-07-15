import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

//table of our valut item
class VaultItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userId => text()();

  TextColumn get title => text()();

  TextColumn get category => text()();

  TextColumn get secretValue => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();
}

//app seeting table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get userId => text().unique()();

  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(true))();

  BoolColumn get pinEnabled => boolean().withDefault(const Constant(true))();

  TextColumn get themeMode => text().withDefault(const Constant('light'))();
}

@DriftDatabase(tables: [VaultItems, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String databasePassword)
    : super(_openConnection(databasePassword));

  @override
  int get schemaVersion => 1;

  // Vault Items Queries
  Future<List<VaultItem>> getVaultItemsByUser(String userId) {
    return (select(vaultItems)
          ..where((item) => item.userId.equals(userId))
          ..orderBy([(item) => OrderingTerm.desc(item.updatedAt)]))
        .get();
  }

  //insert the Item to db
  Future<int> insertVaultItem(VaultItemsCompanion item) {
    return into(vaultItems).insert(item);
  }

  //PUT Operator to update item
  Future<bool> updateVaultItem(VaultItem item) {
    return update(vaultItems).replace(item);
  }

  //DELETE Operator to delete ITEM
  Future<int> deleteVaultItem(int id) {
    return (delete(vaultItems)..where((item) => item.id.equals(id))).go();
  }

  //serch item based on the keyword
  Future<List<VaultItem>> searchVaultItems({
    required String userId,
    required String keyword,
  }) {
    return (select(vaultItems)
          ..where(
            (item) =>
                item.userId.equals(userId) &
                (item.title.contains(keyword) |
                    item.category.contains(keyword) |
                    item.description.contains(keyword)),
          )
          ..orderBy([(item) => OrderingTerm.desc(item.updatedAt)]))
        .get();
  }

  //get valut item based on categoryy
  Future<List<VaultItem>> getVaultItemsByCategory({
    required String userId,
    required String category,
  }) {
    return (select(vaultItems)
          ..where(
            (item) =>
                item.userId.equals(userId) & item.category.equals(category),
          )
          ..orderBy([(item) => OrderingTerm.desc(item.updatedAt)]))
        .get();
  }

  // Settings Queries

  Future<AppSetting?> getSettingsByUser(String userId) {
    return (select(
      appSettings,
    )..where((s) => s.userId.equals(userId))).getSingleOrNull();
  }

  Future<int> insertSettings(AppSettingsCompanion settings) {
    return into(appSettings).insert(settings);
  }

  Future<bool> updateSettings(AppSetting settings) {
    return update(appSettings).replace(settings);
  }
}

// DB Connection use PRAGMA encryption key
LazyDatabase _openConnection(String password) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'raksa_vault.sqlite'));

    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        //decrypt the database upon opening
        rawDb.execute("PRAGMA key = '$password';");
      },
    );
  });
}
