import 'package:flutter/material.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../widgets/category_card.dart';
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

  //load all item by uusing repository
  void _loadVaultItems() {
    _vaultItems = widget.repository.getAllItems(widget.userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _loadVaultItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raksa Vault"),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      //FutureBuilder is a Flutter widget that waits for a Future to finish and buit the ui new
      body: FutureBuilder<List<VaultItem>>(
        future: _vaultItems,
        builder: (context, snapshot) {
          //if connection is wating , show circular spin
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          //error, show error
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          //if it return item
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
        onPressed: () async {
          // Navigate to Add Vault Screen

          // await Navigator.push(...);

          // Reload after returning
          _refresh();
        },
        child: const Icon(Icons.add),
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
