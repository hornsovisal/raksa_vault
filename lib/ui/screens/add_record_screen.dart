import 'package:flutter/material.dart';
import '../../main.dart'; // ✅ Imported main.dart to access global vaultRepository
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class AddRecordScreen extends StatefulWidget {
  final String userId;
  const AddRecordScreen({super.key, required this.userId});

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  //auto set selext password
  String _selectedCategory = 'Passwords';
  bool _obscureSensitive = true;

  // Controllers to capture user input
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

  // the SQLite Database Insert operation
  Future<void> _saveRecord() async {
    //to save record we need that 3
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
      String dbCategory = _selectedCategory;
      if (_selectedCategory == 'Passwords') dbCategory = 'Login';
      if (_selectedCategory == 'Bank Accounts') dbCategory = 'Identity';
      if (_selectedCategory == 'Cards') dbCategory = 'Card';

      //call our repo to add item to db
      await vaultRepository.addItem(
        userId: widget.userId,
        title: title,
        category: dbCategory,
        secretValue: secretValue,
        description: description,
        isFavorite: false,
      );

      // Pop back to the Dashboard returning true so it triggers a refresh
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
      backgroundColor: const Color.fromARGB(255, 211, 217, 245),
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
      //make it scolorable
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey),
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
                  border: Border.all(color: Colors.grey),
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
                  //we can set it to visibility to  see or not
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
                          color: const Color(0xFF1E3A8A),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _obscureSensitive ? 'Show' : 'Hide',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
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
                  color: const Color(0xFFF8F9FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: _sensitiveController,
                      maxLines: _obscureSensitive ? 1 : null,
                      obscureText: _obscureSensitive,
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
                onPressed: _saveRecord,
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

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
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
