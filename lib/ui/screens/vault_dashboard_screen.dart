import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/vault_tile.dart';

class VaultDashboardScreen extends StatelessWidget {
  const VaultDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raksa Vault'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                CategoryCard(
                  title: 'Logins',
                  icon: Icons.login,
                  count: '12 items',
                  onTap: () {},
                ),
                CategoryCard(
                  title: 'Cards',
                  icon: Icons.credit_card,
                  count: '4 items',
                  onTap: () {},
                ),
                CategoryCard(
                  title: 'Secure Notes',
                  icon: Icons.note,
                  count: '8 items',
                  onTap: () {},
                ),
                CategoryCard(
                  title: 'Identities',
                  icon: Icons.person,
                  count: '2 items',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
            const SizedBox(height: 8),
            VaultTile(
              title: 'Google',
              subtitle: 'myemail@gmail.com',
              leadingIcon: const Icon(
                Icons.g_mobiledata,
                size: 32,
                color: Colors.blue,
              ),
              onTap: () {},
            ),
            VaultTile(
              title: 'Netflix',
              subtitle: 'family@email.com',
              leadingIcon: const Icon(Icons.movie, color: Colors.red),
              onTap: () {},
            ),
            VaultTile(
              title: 'Chase Bank',
              subtitle: '**** **** **** 1234',
              leadingIcon: const Icon(
                Icons.account_balance,
                color: Colors.green,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
