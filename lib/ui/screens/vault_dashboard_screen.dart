import 'package:flutter/material.dart';
import 'package:raksa_vault/ui/screens/add_record_screen.dart';
import 'package:raksa_vault/ui/screens/record_detail_screen.dart';
import 'package:raksa_vault/ui/theme/app_theme.dart';
import 'package:raksa_vault/ui/widgets/custom_bottom_nav.dart';
import 'package:raksa_vault/ui/widgets/vault_tile.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../../data/services/firebase_auth_service.dart';
import '../widgets/stat_card.dart';

class VaultDashboardScreen extends StatefulWidget {
  final VaultRepository repository;
  final String userId;

  const VaultDashboardScreen({
    super.key,
    required this.repository,
    required this.userId,
  });

  @override
  State<VaultDashboardScreen> createState() {
    return VaultDashboardScreenState();
  }
}

class VaultDashboardScreenState extends State<VaultDashboardScreen> {
  // future use for get all vault item
  late Future<List<VaultItem>> vaultItems;

  // null mean user select all category
  RecordCategory? selectedCategory;

  // use for bottom nav current index
  int selectedIndex = 0;

  // firebase auth use to get current user
  final FirebaseAuthService authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();

    // load all record when dashbord open
    loadVaultItems();
  }

  // get all item from database
  void loadVaultItems() {
    vaultItems = widget.repository.getAllItems(widget.userId);
  }

  // refresh item after add edit or delet
  Future<void> refreshItems() async {
    setState(() {
      loadVaultItems();
    });

    await vaultItems;
  }

  // convert category db value to enum
  RecordCategory? getRecordCategory(String dbValue) {
    for (final category in RecordCategory.values) {
      if (category.dbValue == dbValue) {
        return category;
      }
    }

    // return null if category not found
    return null;
  }

  // get icon base on enum category
  IconData getCategoryIcon(RecordCategory? category) {
    switch (category) {
      case RecordCategory.passwords:
        return Icons.key;

      case RecordCategory.bankAccounts:
        return Icons.account_balance;

      case RecordCategory.cards:
        return Icons.credit_card;

      case null:
        return Icons.lock;
    }
  }

  // get category nice name for show in ui
  String getCategoryDisplayName(String dbValue) {
    final category = getRecordCategory(dbValue);

    // if category found show display name
    // if not found show old db value
    return category?.displayName ?? dbValue;
  }

  // find latest record update time
  String getLastUpdated(List<VaultItem> items) {
    // no item mean no update time
    if (items.isEmpty) {
      return '-';
    }

    // copy list so we dont change orginal list
    final sortedItems = List<VaultItem>.from(items);

    // sort newest item to first
    sortedItems.sort((first, second) {
      return second.updatedAt.compareTo(first.updatedAt);
    });

    final latestDate = sortedItems.first.updatedAt;
    final difference = DateTime.now().difference(latestDate);

    // update less than 1 minute
    if (difference.inMinutes < 1) {
      return 'Now';
    }

    // update less than 1 hour
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    }

    // update less than 1 day
    if (difference.inHours < 24) {
      return '${difference.inHours}h';
    }

    // update more than 1 day
    return '${difference.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    // get current login user
    final user = authService.currentUser;

    // use User if full name not found
    final userName = user?.fullName ?? 'User';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      // top app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, $userName',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Welcome back to Raksa Vault',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // notifcation action later
            },
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),

      // wait database item load
      body: FutureBuilder<List<VaultItem>>(
        future: vaultItems,
        builder: (context, snapshot) {
          // show loading while wait data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // show error if load item fail
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          // get item or empty list
          final items = snapshot.data ?? [];

          // count total record
          final totalRecords = items.length;

          // count category that have record
          final totalCategories = items
              .map((item) {
                return getRecordCategory(item.category);
              })
              .whereType<RecordCategory>()
              .toSet()
              .length;

          // get latest update time
          final lastUpdated = getLastUpdated(items);

          // item after category filter
          final List<VaultItem> filteredItems;

          // null mean show all record
          if (selectedCategory == null) {
            filteredItems = items;
          } else {
            // filter record by category user select
            filteredItems = items.where((item) {
              return item.category == selectedCategory!.dbValue;
            }).toList();
          }

          return RefreshIndicator(
            // pull down to refresh record
            onRefresh: refreshItems,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // dashbord summary card
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Records',
                        value: totalRecords.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        title: 'Categories',
                        value: totalCategories.toString(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StatCard(title: 'Last Used', value: lastUpdated),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // category title
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 10),

                // horizontal category filter
                SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // all category button
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All'),

                          // null mean all category selected
                          selected: selectedCategory == null,

                          selectedColor: const Color(0xFF0F172A),
                          backgroundColor: const Color(0xFFE2E8F0),

                          labelStyle: TextStyle(
                            color: selectedCategory == null
                                ? Colors.white
                                : const Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),

                          onSelected: (_) {
                            setState(() {
                              // select all category
                              selectedCategory = null;
                            });
                          },
                        ),
                      ),

                      // create chip from enum category
                      ...RecordCategory.values.map((category) {
                        final isSelected = selectedCategory == category;

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            // category icon
                            avatar: Icon(
                              getCategoryIcon(category),
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),

                            // show enum display name
                            label: Text(category.displayName),

                            selected: isSelected,
                            selectedColor: const Color(0xFF0F172A),
                            backgroundColor: const Color(0xFFE2E8F0),

                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),

                            onSelected: (_) {
                              setState(() {
                                // save category user select
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // recent item title
                const Text(
                  'Recent Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 12),

                // show empty ui if no item found
                if (filteredItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Icon(Icons.folder_open, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'No vault items found',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                      ],
                    ),
                  )
                else
                  // loop all filter item and make tile
                  ...filteredItems.map((item) {
                    // convert item db category to enum
                    final category = getRecordCategory(item.category);

                    return VaultTile(
                      title: item.title,

                      // show category if description empty
                      subtitle: item.description.isEmpty
                          ? getCategoryDisplayName(item.category)
                          : item.description,

                      // show icon base on category
                      leadingIcon: Icon(
                        getCategoryIcon(category),
                        color: AppColors.primary,
                      ),

                      onTap: () async {
                        // open record detail screeen
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return RecordDetailScreen(
                                item: item,
                                repository: widget.repository,
                              );
                            },
                          ),
                        );

                        // refresh if record edit or delet
                        await refreshItems();
                      },
                    );
                  }),
              ],
            ),
          );
        },
      ),

      // add new record button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F172A),
        onPressed: () async {
          // open add record screeen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AddRecordScreen(userId: widget.userId);
              },
            ),
          );

          // refresh after new record save
          if (result == true) {
            await refreshItems();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // custom bottom navigation
      bottomNavigationBar: CustomBottomNav(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            // change selected nav index
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
