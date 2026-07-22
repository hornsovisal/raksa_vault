import 'package:flutter/material.dart';
import 'package:raksa_vault/models/record_category.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../theme/app_theme.dart';

class CategoryScreen extends StatefulWidget {
  // current user id
  final String userId;

  // repository use to get sqlite data
  final VaultRepository repository;

  const CategoryScreen({
    super.key,
    required this.userId,
    required this.repository,
  });

  @override
  State<CategoryScreen> createState() {
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen> {
  // get search input
  final searchController = TextEditingController();

  // current search text
  String searchText = '';

  // future hold sqlite items
  late Future<List<VaultItem>> itemsFuture;

  @override
  void initState() {
    super.initState();

    // load record when screen open
    loadItems();
  }

  // get all current user items from sqlite
  void loadItems() {
    itemsFuture = widget.repository.getAllItems(widget.userId);
  }

  // refresh data from sqlite
  Future<void> refreshItems() async {
    setState(() {
      loadItems();
    });

    await itemsFuture;
  }

  // count item for one category
  int getCategoryCount(List<VaultItem> items, RecordCategory category) {
    return items.where((item) {
      // change sqlite string to enum before compare
      final itemCategory = RecordCategory.fromDbValue(item.category);

      return itemCategory == category;
    }).length;
  }

  // format item count
  String getItemText(int count) {
    if (count == 1) {
      return '1 Item';
    }

    return '$count Items';
  }

  // get category color
  Color getCategoryColor(RecordCategory category) {
    switch (category) {
      case RecordCategory.passwords:
        return AppColors.tertiary;

      case RecordCategory.bankAccounts:
        return AppColors.secondary;

      case RecordCategory.cards:
        return AppColors.primary;

      case RecordCategory.notes:
        return AppColors.textMuted;

      case RecordCategory.other:
        return AppColors.error;
    }
  }

  @override
  void dispose() {
    // clear search controller when screen close
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // filter category using search input
    final filteredCategories = RecordCategory.values.where((category) {
      return category.displayName.toLowerCase().contains(
        searchText.toLowerCase(),
      );
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Category',
          style: AppTextStyles.title.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // search category
            TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search categories...',
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textMuted,
                ),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            searchText = '';
                          });
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.textMuted,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.card,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // load data from sqlite
            Expanded(
              child: FutureBuilder<List<VaultItem>>(
                future: itemsFuture,
                builder: (context, snapshot) {
                  // show loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // show error
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Failed to load categories',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                loadItems();
                              });
                            },
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  // sqlite result
                  final items = snapshot.data ?? [];

                  // no category match search
                  if (filteredCategories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 48,
                            color: AppColors.textMuted,
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'No category found',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: refreshItems,
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 24),
                      itemCount: filteredCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                      itemBuilder: (context, index) {
                        final category = filteredCategories[index];

                        // real count from sqlite
                        final count = getCategoryCount(items, category);

                        final categoryColor = getCategoryColor(category);

                        return buildCategoryCard(
                          category: category,
                          subtitle: getItemText(count),
                          iconBackgroundColor: categoryColor.withValues(
                            alpha: 0.12,
                          ),
                          iconColor: categoryColor,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // make one category card
  Widget buildCategoryCard({
    required RecordCategory category,
    required String subtitle,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () async {
          // get selected category item from sqlite
          final categoryItems = await widget.repository.getItemsByCategory(
            userId: widget.userId,
            category: category,
          );

          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${category.displayName}: ${categoryItems.length} items',
              ),
            ),
          );

          // later you can open category item screen here
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(category.icon, color: iconColor),
              ),

              const SizedBox(height: 12),

              Text(
                category.displayName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: AppTextStyles.label.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
