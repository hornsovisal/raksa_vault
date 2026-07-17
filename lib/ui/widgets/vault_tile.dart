import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VaultTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? leadingIcon;
  final Widget? trailing;
  final VoidCallback onTap;

  const VaultTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leadingIcon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child:
              leadingIcon ??
              const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.textMuted),
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ),
    );
  }
}
