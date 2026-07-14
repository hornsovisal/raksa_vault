import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import 'vault_dashboard_screen.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({super.key});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  String _selectedCategory = 'Passwords';
  final _titleController = TextEditingController();
  final _secretValueController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _secretValueController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
          'Add New Record',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF64748B),
                    ),
                    items: ['Passwords', 'Bank Accounts', 'Cards'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() => _selectedCategory = newValue);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildLabel('Record Title'),
              const SizedBox(height: 8),
              _buildTextField(
                'Enter title (e.g. Netflix Primary)',
                controller: _titleController,
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Sensitive Information'),
                  Row(
                    children: [
                      const Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Color(0xFF1E3A8A),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Hide',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _secretValueController,
                      maxLines: null,
                      decoration: const InputDecoration.collapsed(
                        hintText:
                            'Paste password, key, or\nsensitive text here...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF94A3B8),
                          fontFamily: 'monospace',
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.content_paste,
                          size: 16,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.sort, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  _buildLabel('Description (Optional)'),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                'Add any notes here...',
                controller: _descriptionController,
              ),

              const SizedBox(height: 32),
              CustomButton(
                text: 'Save Record',
                backgroundColor: const Color(0xFF0F172A),
                onPressed: () async {
                  final title = _titleController.text.isEmpty
                      ? 'Untitled Record'
                      : _titleController.text;
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await vaultRepository.addItem(
                      userId: user.uid,
                      title: title,
                      category: _selectedCategory,
                      secretValue: _secretValueController.text,
                      description: _descriptionController.text,
                      isFavorite: false,
                    );
                  }
                  if (mounted) {
                    Navigator.pop(
                      context,
                      VaultRecord(
                        title: title,
                        category: _selectedCategory,
                        subtitle: '••••••••',
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Cancel',
                backgroundColor: Colors.transparent,
                textColor: const Color(0xFF64748B),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildTextField(String hint, {TextEditingController? controller}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
