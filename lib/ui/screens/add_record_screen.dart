import 'package:flutter/material.dart';
import '../../main.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

enum RecordCategory {
  passwords(displayName: 'Passwords', dbValue: 'Login'),
  bankAccounts(displayName: 'Bank Accounts', dbValue: 'Identity'),
  cards(displayName: 'Cards', dbValue: 'Card');

  final String displayName;
  final String dbValue;

  const RecordCategory({required this.displayName, required this.dbValue});
}

class AddRecordScreen extends StatefulWidget {
  final String userId;
  const AddRecordScreen({super.key, required this.userId});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  RecordCategory _selectedCategory = RecordCategory.passwords;
  bool _obscureSensitive = true;

  final _titleController = TextEditingController();
  final _sensitiveController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _sensitiveController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveRecord() async {
    final title = _titleController.text.trim();
    final secretValue = _sensitiveController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a record title')),
      );
      return;
    }

    try {
      //add item to our db
      await vaultRepository.addItem(
        userId: widget.userId,
        title: title,
        category: _selectedCategory.dbValue,
        secretValue: secretValue,
        description: description,
        isFavorite: false,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save to database: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add New Record',
          style: AppTextStyles.headline.copyWith(
            fontSize: 18,
            color: AppColors.tertiary,
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
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Category'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  // 4. Update Dropdown to use RecordCategory type
                  child: DropdownButton<RecordCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textMuted,
                    ),
                    // Map over the enum values automatically
                    items: RecordCategory.values.map((RecordCategory category) {
                      return DropdownMenuItem<RecordCategory>(
                        value: category,
                        child: Text(
                          category.displayName,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textDark,
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
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureSensitive = !_obscureSensitive;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          _obscureSensitive
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _obscureSensitive ? 'Show' : 'Hide',
                          style: AppTextStyles.label.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _sensitiveController,
                      maxLines: _obscureSensitive ? 1 : null,
                      obscureText: _obscureSensitive,
                      decoration: InputDecoration.collapsed(
                        hintText:
                            'Paste password, key, or\nsensitive text here...',
                        hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textMuted,
                          fontFamily: 'monospace',
                        ),
                      ),
                      style: AppTextStyles.body.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.content_paste,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.sort, size: 14, color: AppColors.textMuted),
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
                backgroundColor: AppColors.textDark,
                onPressed: _saveRecord,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Cancel',
                backgroundColor: Colors.transparent,
                textColor: AppColors.textMuted,
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
      style: AppTextStyles.label.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        style: AppTextStyles.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
