import 'package:flutter/material.dart';
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
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  bool _isVerified = false;
  String? _errorMsg;

  void _handlePinEntered(String pin) async {
    final isValid = await PinService().verifyPin(pin);
    if (!mounted) return;

    if (isValid) {
      setState(() {
        _isVerified = true;
        _errorMsg = null;
      });
    } else {
      setState(() {
        _errorMsg = 'Incorrect PIN';
      });
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
          _isVerified ? widget.item.title : 'Verify PIN',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: _isVerified ? _buildDetails() : _buildPinVerification(),
    );
  }

  Widget _buildPinVerification() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 48, color: Color(0xFF1E3A8A)),
          const SizedBox(height: 16),
          const Text(
            'Enter PIN to view details',
            style: TextStyle(color: AppColors.textBody),
          ),
          const SizedBox(height: 32),
          PinPad(
            pinLength: 6,
            onPinEntered: _handlePinEntered,
            errorText: _errorMsg,
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Category', widget.item.category),
          const SizedBox(height: 24),
          _buildDetailItem('Title', widget.item.title),
          const SizedBox(height: 24),
          _buildDetailItem(
            'Sensitive Information',
            widget
                .item
                .secretValue, // ✅ Pulled directly from database secret record
            isSensitive: true,
          ),
          const SizedBox(height: 24),
          _buildDetailItem(
            'Description (Notes)',
            widget.item.description.isEmpty
                ? 'No additional notes'
                : widget.item.description,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    bool isSensitive = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF1E293B),
                    fontFamily: isSensitive ? 'monospace' : null,
                  ),
                ),
              ),
              if (isSensitive)
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    size: 18,
                    color: Color(0xFF1E3A8A),
                  ),
                  onPressed: () {
                    // Quick convenience copy logic
                    ScaffoldMessenger.of(context).showSnackBar(
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
}
