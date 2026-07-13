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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child:
              leadingIcon ??
              const Icon(Icons.lock_outline, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: AppColors.textMuted),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing:
            trailing ??
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
      ),
    );
  }
}
