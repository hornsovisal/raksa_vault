import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raksa_vault/models/record_category.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/vault_repository.dart';
import '../../data/services/pin_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pin_pad.dart';
import 'face_scan_screen.dart';

class RecordDetailScreen extends StatefulWidget {
  final VaultItem item;
  final VaultRepository repository;

  const RecordDetailScreen({
    super.key,
    required this.item,
    required this.repository,
  });

  @override
  State<RecordDetailScreen> createState() {
    return RecordDetailScreenState();
  }
}

class RecordDetailScreenState extends State<RecordDetailScreen> {
  // false mean user still need face or pin verify
  bool isVerified = false;

  // stop face screen open more than one time
  bool faceScanOpened = false;

  // show pin error message
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    // call face scan first after screen open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openFaceScanFirst();
    });
  }

  // open face authentication first
  Future<void> openFaceScanFirst() async {
    // dont open face screen more than one time automatically
    if (faceScanOpened || isVerified || !mounted) {
      return;
    }

    faceScanOpened = true;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const FaceScanScreen();
        },
      ),
    );

    // face authentication success
    if (result == true) {
      setState(() {
        isVerified = true;
        errorMessage = null;
      });
    }

    // false or null mean show pin screen
  }

  // manually open face scan again
  Future<void> retryFaceScan() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
          return const FaceScanScreen();
        },
      ),
    );

    if (result == true) {
      setState(() {
        isVerified = true;
        errorMessage = null;
      });
    }
  }

  // change database category string to enum
  RecordCategory getCategory() {
    return RecordCategory.fromDbValue(widget.item.category);
  }

  // get icon based on category
  IconData getCategoryIcon(RecordCategory category) {
    switch (category) {
      case RecordCategory.passwords:
        return Icons.key_outlined;

      case RecordCategory.bankAccounts:
        return Icons.account_balance_outlined;

      case RecordCategory.cards:
        return Icons.credit_card_outlined;

      case RecordCategory.notes:
        return Icons.note_outlined;

      case RecordCategory.other:
        return Icons.folder_outlined;
    }
  }

  // show confirm dialog before delete
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
                // close dialog
                Navigator.pop(dialogContext);

                try {
                  // delete record from sqlite
                  await widget.repository.deleteItem(widget.item.id);

                  // go back and tell dashboard to refresh by return true
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                } catch (e) {
                  // show error if delete fail
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete record: $e')),
                    );
                  }
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

  // check pin user entered
  Future<void> handlePinEntered(String pin) async {
    final isValid = await PinService().verifyPin(pin);

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

  // copy text to clipboard
  Future<void> copyToClipboard(String value) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  // pin verification ui
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
                'Use face authentication or enter your PIN',
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),

              const SizedBox(height: 24),

              // retry face authentication
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: retryFaceScan,
                  icon: const Icon(Icons.face_retouching_natural),
                  label: const Text('Scan Face'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or use PIN',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),

              const SizedBox(height: 24),

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

  // record details ui
  Widget buildDetails() {
    // convert sqlite category value to enum
    final category = getCategory();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // category
          buildDetailItem(
            label: 'Category',
            value: category.displayName,
            icon: getCategoryIcon(category),
          ),

          const SizedBox(height: 20),

          // record title
          buildDetailItem(
            label: 'Title',
            value: widget.item.title,
            icon: Icons.title,
          ),

          const SizedBox(height: 20),

          // secret value
          buildDetailItem(
            label: 'Sensitive Information',
            value: widget.item.secretValue.trim().isEmpty
                ? 'No sensitive information'
                : widget.item.secretValue,
            icon: Icons.shield_outlined,
            isSensitive: true,
          ),

          const SizedBox(height: 20),

          // description
          buildDetailItem(
            label: 'Description (Notes)',
            value: widget.item.description.trim().isEmpty
                ? 'No additional notes'
                : widget.item.description,
            icon: Icons.notes_outlined,
          ),
        ],
      ),
    );
  }

  // reusable detail card
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
          style: AppTextStyles.label.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // field icon
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

              // field value
              Expanded(
                child: SelectableText(
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

              // copy secret button
              if (isSensitive && widget.item.secretValue.trim().isNotEmpty)
                IconButton(
                  tooltip: 'Copy',
                  icon: const Icon(
                    Icons.copy_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    copyToClipboard(widget.item.secretValue);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          isVerified ? widget.item.title : 'Verify Identity',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
