import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../../data/services/pin_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pin_pad.dart';

class RecordDetailScreen extends StatefulWidget {
  final VaultItem item;
  final VaultRepository repository;

  const RecordDetailScreen({
    super.key,
    required this.item,
    required this.repository,
  });

  @override
  State<RecordDetailScreen> createState() => RecordDetailScreenState();
}

class RecordDetailScreenState extends State<RecordDetailScreen> {
  bool isVerified = false;
  String? errorMessage;

  // Show confirm dialog before deleting the record
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Record', style: AppTextStyles.subtitle),
          content: const Text(
            'Are you sure you want to delete this record? '
            'This action cannot be undone.',
            style: AppTextStyles.body,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await widget.repository.deleteItem(widget.item.id);

                if (mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Check the PIN entered by the user
  Future<void> handlePinEntered(String pin) async {
    final isValid = await PinService().verifyPin(pin);

    if (!mounted) {
      return;
    }

    if (isValid) {
      setState(() {
        isVerified = true;
        errorMessage = null;
      });
    } else {
      setState(() {
        errorMessage = 'Incorrect PIN';
      });
    }
  }

  // PIN verification widget
  Widget buildPinVerification() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Protected Record', style: AppTextStyles.title),
              const SizedBox(height: 8),
              const Text(
                'Enter your PIN to view the record details',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 32),
              PinPad(
                pinLength: 6,
                onPinEntered: handlePinEntered,
                errorText: errorMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Record details widget
  Widget buildDetails() {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          buildDetailItem(
            label: 'Category',
            value: widget.item.category,
            icon: Icons.category_outlined,
          ),
          const SizedBox(height: 20),
          buildDetailItem(
            label: 'Title',
            value: widget.item.title,
            icon: Icons.title,
          ),
          const SizedBox(height: 20),
          buildDetailItem(
            label: 'Sensitive Information',
            value: widget.item.secretValue,
            icon: Icons.shield_outlined,
            isSensitive: true,
          ),
          const SizedBox(height: 20),
          buildDetailItem(
            label: 'Description (Notes)',
            value: widget.item.description.isEmpty
                ? 'No additional notes'
                : widget.item.description,
            icon: Icons.notes_outlined,
          ),
        ],
      ),
    );
  }

  // Reusable detail item widget
  Widget buildDetailItem({
    required String label,
    required String value,
    required IconData icon,
    bool isSensitive = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.label.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 21, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontFamily: isSensitive ? 'monospace' : null,
                    fontWeight: isSensitive
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (isSensitive)
                IconButton(
                  tooltip: 'Copy',
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Main screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          isVerified ? widget.item.title : 'Verify PIN',
          style: AppTextStyles.subtitle.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: isVerified
            ? [
                IconButton(
                  tooltip: 'Delete record',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.error,
                  ),
                  onPressed: confirmDelete,
                ),
              ]
            : null,
      ),
      body: isVerified ? buildDetails() : buildPinVerification(),
    );
  }
}
