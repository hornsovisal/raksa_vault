import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
            // Search categories
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
              ),
            ),

            const SizedBox(height: 16),

            // Category list
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildCategoryCard(
                    title: 'Passwords',
                    subtitle: '12 Items',
                    icon: Icons.password,
                    iconBackgroundColor: AppColors.tertiary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.tertiary,
                  ),
                  _buildCategoryCard(
                    title: 'Bank Accounts',
                    subtitle: '4 Items',
                    icon: Icons.account_balance,
                    iconBackgroundColor: AppColors.secondary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.secondary,
                  ),
                  _buildCategoryCard(
                    title: 'Credit Cards',
                    subtitle: '3 Items',
                    icon: Icons.credit_card,
                    iconBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.primary,
                  ),
                  _buildCategoryCard(
                    title: 'Recovery Codes',
                    subtitle: '8 Items',
                    icon: Icons.qr_code,
                    iconBackgroundColor: AppColors.error.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.error,
                  ),
                  _buildCategoryCard(
                    title: 'Private Notes',
                    subtitle: '15 Items',
                    icon: Icons.description,
                    iconBackgroundColor: AppColors.textMuted.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.textMuted,
                  ),
                  _buildCategoryCard(
                    title: 'Wi-Fi',
                    subtitle: '6 Items',
                    icon: Icons.wifi,
                    iconBackgroundColor: AppColors.tertiary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.tertiary,
                  ),
                  _buildCategoryCard(
                    title: 'Licenses',
                    subtitle: '2 Items',
                    icon: Icons.badge,
                    iconBackgroundColor: AppColors.secondary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.secondary,
                  ),
                  _buildCategoryCard(
                    title: 'Identity',
                    subtitle: '1 Item',
                    icon: Icons.person,
                    iconBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.12,
                    ),
                    iconColor: AppColors.primary,
                  ),
                ],
              ),
            ),

            // Emergency category
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 16, bottom: 24),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.emergency, color: AppColors.error),
                  ),
                  const SizedBox(height: 8),
                  const Text('Emergency', style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  const Text('Configured', style: AppTextStyles.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          // Open the selected category
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
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.label),
            ],
          ),
        ),
      ),
    );
  }
}
