[7/14/26 4:06 PM] KUE CHANCHESSIKA: import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart'; // To access vaultRepository
import '../../data/database/app_database.dart';
import '../theme/app_theme.dart';
import 'add_record_screen.dart';

class VaultRecord {
  final String title;
  final String category;
  final String subtitle;
  VaultRecord({required this.title, required this.category, required this.subtitle});
}

class VaultDashboardScreen extends StatefulWidget {
  const VaultDashboardScreen({super.key});

  @override
  State<VaultDashboardScreen> createState() => _VaultDashboardScreenState();
}

class _VaultDashboardScreenState extends State<VaultDashboardScreen> {
  int _currentIndex = 0;
  late Future<List<VaultItem>> _vaultItems;

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

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "login":
      case "logins":
        return Icons.login;
      case "card":
      case "cards":
        return Icons.credit_card;
      case "note":
      case "secure notes":
        return Icons.note;
      case "identity":
      case "identities":
        return Icons.person;
      case "bank accounts":
        return Icons.account_balance;
      default:
        return Icons.lock;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Vault',
          style: AppTextStyles.headline.copyWith(fontSize: 20, color: const Color(0xFF1E3A8A)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1E293B)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<List<VaultItem>>(
        future: _vaultItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];
          final categoriesCount = items.map((e) => e.category).toSet().length;
[7/14/26 4:06 PM] KUE CHANCHESSIKA: return Container(
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