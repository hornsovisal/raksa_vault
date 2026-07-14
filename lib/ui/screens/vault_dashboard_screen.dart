import 'package:flutter/material.dart';
import 'package:raksa_vault/ui/screens/add_record_screen.dart';
import 'package:raksa_vault/ui/screens/record_detail_screen.dart';
import 'package:raksa_vault/ui/theme/app_theme.dart';
import 'package:raksa_vault/ui/widgets/CustomButtomNav.dart';

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
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
        title: Row(
          children: [
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning, ${user?.fullName}", // Dynamic Greeting
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Welcome back to Raksa Vault",
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textDark,
            ),
            onPressed: () {},
          ),
        ],
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

          // Calculate Statistics
          final totalRecords = items.length;
          final totalCategories = items.map((e) => e.category).toSet().length;
          String lastUpdated = "-";

          if (items.isNotEmpty) {
            final latest = items.first;
            final diff = DateTime.now().difference(latest.updatedAt);

            if (diff.inMinutes < 60) {
              lastUpdated = "${diff.inMinutes}m";
            } else if (diff.inHours < 24) {
              lastUpdated = "${diff.inHours}h";
            } else {
              lastUpdated = "${diff.inDays}d";
            }
          }

          // Build dynamic unique categories list from items
          final categories = ["All", ...items.map((e) => e.category).toSet()];

          final filteredItems = _selectedCategory == "All"
              ? items
              : items.where((e) => e.category == _selectedCategory).toList();

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Stat Cards Row
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
                    Expanded(
                      child: StatCard(title: "Last Used", value: lastUpdated),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Category Text Header
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Horizontal Dynamic Filter Chips
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        child: _buildChip(category, isSelected),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Items Header
                const Text(
                  "Recent Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                if (filteredItems.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "No vault items found.",
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...filteredItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecordDetailScreen(
                                item: item,
                                repository: widget.repository,
                              ),
                            ),
                          );
                          _refresh();
                        },
                        child: _buildListItem(item),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddRecordScreen(userId: widget.userId),
            ),
          );
          if (result == true) {
            await _refresh();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // Helper method representing custom design of chips
  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Helper method representing custom design of list item
  Widget _buildListItem(VaultItem record) {
    IconData icon = _getCategoryIcon(record.category);
    Color bgColor;
    Color iconColor;

    if (record.category.toLowerCase().contains('bank') ||
        record.category.toLowerCase().contains('card')) {
      bgColor = const Color(0xFFD1FAE5);
      iconColor = const Color(0xFF059669);
    } else {
      bgColor = const Color(0xFFEFF6FF);
      iconColor = const Color(0xFF1E3A8A);
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.description.isEmpty ? "••••••••" : record.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }
}
