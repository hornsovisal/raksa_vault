import 'package:flutter/material.dart';
import 'package:raksa_vault/ui/widgets/CustomButtomNav.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../../data/services/firebase_auth_service.dart';
import '../widgets/stat_card.dart';
import '../widgets/vault_tile.dart';

class VaultDashboardScreen extends StatefulWidget {
  final VaultRepository repository;
  final String userId;

  const VaultDashboardScreen({
    super.key,
    required this.repository,
    required this.userId,
  });

  @override
  State<VaultDashboardScreen> createState() => _VaultDashboardScreenState();
}

class _VaultDashboardScreenState extends State<VaultDashboardScreen> {
  late Future<List<VaultItem>> _vaultItems;

  int _selectedIndex = 0;
  String _selectedCategory = "All";

  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _loadVaultItems();
  }

  void _loadVaultItems() {
    _vaultItems = widget.repository.getAllItems(widget.userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadVaultItems();
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "login":
        return Icons.login;
      case "card":
        return Icons.credit_card;
      case "note":
        return Icons.note;
      case "identity":
        return Icons.person;
      default:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Raksa Vault"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),

      body: FutureBuilder<List<VaultItem>>(
        future: _vaultItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final items = snapshot.data ?? [];

          final totalRecords = items.length;

          final totalCategories = items.map((e) => e.category).toSet().length;

          final categories = ["All", ...items.map((e) => e.category).toSet()];

          final filteredItems = _selectedCategory == "All"
              ? items
              : items.where((e) => e.category == _selectedCategory).toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),

              children: [
                Text(
                  "Good Morning ${user?.fullName}",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Welcome back to your secure vault.",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: "Records",
                        value: totalRecords.toString(),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: StatCard(
                        title: "Categories",
                        value: totalCategories.toString(),
                      ),
                    ),

                    const SizedBox(width: 12),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          selected: _selectedCategory == category,
                          label: Text(category),
                          onSelected: (_) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                if (filteredItems.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text("No vault items found."),
                    ),
                  ),

                ...filteredItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: VaultTile(
                      title: item.title,
                      subtitle: item.description.isEmpty
                          ? "••••••••"
                          : item.description,
                      leadingIcon: Icon(
                        _getCategoryIcon(item.category),
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await Navigator.push(...AddVaultScreen());

          await _refresh();
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // TODO:
          // Navigate to Search
          // Categories
          // Settings
        },
      ),
    );
  }
}
