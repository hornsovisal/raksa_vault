import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart'; // To access vaultRepository
import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../widgets/category_card.dart';
import '../widgets/vault_tile.dart';

class VaultDashboardScreen extends StatefulWidget {
  const VaultDashboardScreen({super.key});

  @override
  State<VaultDashboardScreen> createState() => _VaultDashboardScreenState();
}

class _VaultDashboardScreenState extends State<VaultDashboardScreen> {
  int _currentIndex = 0;
  late Future<List<VaultItem>> _vaultItems;
  // Return the  icon based on the vault item category.
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
  void initState() {
    super.initState();
    _loadVaultItems();
  }

  void _loadVaultItems() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _vaultItems = vaultRepository.getAllItems(user.uid);
    } else {
      _vaultItems = Future.value([]);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _loadVaultItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Raksa Vault"),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      //FutureBuilder is a Flutter widget that waits for a Future to finish and buit the ui new
      body: FutureBuilder<List<VaultItem>>(
        future: _vaultItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //error, show error
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final items = snapshot.data ?? [];

          //find the login category
          final loginCount = items
              .where((e) => e.category.toLowerCase() == "login")
              .length;

          //find the card category

          final cardCount = items
              .where((e) => e.category.toLowerCase() == "card")
              .length;

          //find the note category

          final noteCount = items
              .where((e) => e.category.toLowerCase() == "note")
              .length;

          //find the identify category

          final identityCount = items
              .where((e) => e.category.toLowerCase() == "identity")
              .length;

          //return the category
          return RefreshIndicator(
            onRefresh: _refresh,
            //make it scorelable , can use listview builder as well
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  //show vategoryas grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    children: [
                      CategoryCard(
                        title: "Logins",
                        icon: Icons.login,
                        count: "$loginCount items",
                        onTap: () {
                          //should redireict to category of login
                        },
                      ),
                      CategoryCard(
                        title: "Cards",
                        icon: Icons.credit_card,
                        count: "$cardCount items",
                        onTap: () {},
                      ),
                      CategoryCard(
                        title: "Secure Notes",
                        icon: Icons.note,
                        count: "$noteCount items",
                        onTap: () {},
                      ),
                      CategoryCard(
                        title: "Identities",
                        icon: Icons.person,
                        count: "$identityCount items",
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Items",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("See All"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          "No vault items found.",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return VaultTile(
                          title: item.title,
                          subtitle: item.description,
                          leadingIcon: Icon(
                            _getCategoryIcon(item.category),
                            color: Theme.of(context).primaryColor,
                          ),
                          onTap: () {
                            // TODO: Open detail page
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () async {
          // Navigate to Add Vault Screen

          // await Navigator.push(...);

          // Reload after returning
          _refresh();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF059669),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? const Color(0xFF6EE7B7)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.lock,
                color: _currentIndex == 0
                    ? const Color(0xFF059669)
                    : Colors.grey,
              ),
            ),
            label: 'Vault',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.search),
            ),
            label: 'Search',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.grid_view),
            ),
            label: 'Categories',
          ),
          const BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Icon(Icons.settings),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF64748B),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildListItem(VaultItem record) {
    IconData icon = _getCategoryIcon(record.category);
    Color bgColor;
    Color iconColor;

    if (record.category.toLowerCase().contains('bank')) {
      bgColor = const Color(0xFFD1FAE5);
      iconColor = const Color(0xFF059669);
    } else if (record.category.toLowerCase().contains('card')) {
      bgColor = const Color(0xFFD1FAE5);
      iconColor = const Color(0xFF059669);
    } else {
      bgColor = const Color(0xFFEFF6FF);
      iconColor = const Color(0xFF1E3A8A);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                  record.description,
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
//When you navigate to the add-item screen, do:
// await Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (_) => AddVaultScreen(),
//   ),
// );

// _refresh();
