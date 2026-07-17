import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        automaticallyImplyLeading: false, // hide back button since it's a tab
        title: const Text(
          'Category',
          style: TextStyle(
            color: Color(0xFF1E3A8A), // Dark blue
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid View
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildCategoryCard('Passwords', '12 Items', Icons.password, const Color(0xFFE0E7FF), const Color(0xFF3B82F6)),
                  _buildCategoryCard('Bank Accounts', '4 Items', Icons.account_balance, const Color(0xFFD1FAE5), const Color(0xFF10B981)),
                  _buildCategoryCard('Credit Cards', '3 Items', Icons.credit_card, const Color(0xFFEDE9FE), const Color(0xFF8B5CF6)),
                  _buildCategoryCard('Recovery Codes', '8 Items', Icons.qr_code, const Color(0xFFFFE4E6), const Color(0xFFF43F5E)),
                  _buildCategoryCard('Private Notes', '15 Items', Icons.description, const Color(0xFFF1F5F9), const Color(0xFF64748B)),
                  _buildCategoryCard('Wi-Fi', '6 Items', Icons.wifi, const Color(0xFFE0E7FF), const Color(0xFF3B82F6)),
                  _buildCategoryCard('Licenses', '2 Items', Icons.badge, const Color(0xFFD1FAE5), const Color(0xFF10B981)),
                  _buildCategoryCard('Identity', '1 Item', Icons.person, const Color(0xFFEDE9FE), const Color(0xFF8B5CF6)),
                ],
              ),
            ),
            // Emergency Card
            Container(
              margin: const EdgeInsets.only(bottom: 24, top: 16),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE4E6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency, color: Color(0xFFF43F5E)),
                  ),
                  const SizedBox(height: 8),
                  const Text('Emergency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Configured', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String subtitle, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
