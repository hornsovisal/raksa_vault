import 'package:flutter/material.dart';
import '../../data/services/pin_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pin_pad.dart';
import 'vault_dashboard_screen.dart'; // for VaultRecord

class RecordDetailScreen extends StatefulWidget {
  final VaultRecord record;

  const RecordDetailScreen({super.key, required this.record});

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
          _isVerified ? widget.record.title : 'Verify PIN',
          style: AppTextStyles.headline.copyWith(fontSize: 18, color: const Color(0xFF1E3A8A)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          const Text('Enter PIN to view details', style: TextStyle(color: AppColors.textBody)),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailItem('Category', widget.record.category),
          const SizedBox(height: 24),
          _buildDetailItem('Title', widget.record.title),
          const SizedBox(height: 24),
          _buildDetailItem('Sensitive Information', widget.record.subtitle),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
          ),
        ),
      ],
    );
  }
}
