import 'package:flutter/material.dart';
import '../../main.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';

// all record category
enum RecordCategory {
  passwords(displayName: 'Passwords', dbValue: 'Login'),
  bankAccounts(displayName: 'Bank Accounts', dbValue: 'Identity'),
  cards(displayName: 'Cards', dbValue: 'Card');

  // name show to user
  final String displayName;

  // value save to database
  final String dbValue;

  const RecordCategory({required this.displayName, required this.dbValue});
}

class AddRecordScreen extends StatefulWidget {
  // current user id
  final String userId;

  const AddRecordScreen({super.key, required this.userId});

  @override
  State<AddRecordScreen> createState() {
    return AddRecordScreenState();
  }
}

class AddRecordScreenState extends State<AddRecordScreen> {
  // make label text
  Widget buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    );
  }

  // make normal input box
  Widget buildTextField(
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

  // default category
  RecordCategory selectedCategory = RecordCategory.passwords;

  // true mean hide secret
  // false mean show secret
  bool isHidden = true;

  // get value from input
  final titleController = TextEditingController();
  final secretController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    // clear controller when screen close
    titleController.dispose();
    secretController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // save new record
  Future<void> saveRecord() async {
    // get input value
    final title = titleController.text.trim();
    final secretValue = secretController.text.trim();
    final description = descriptionController.text.trim();

    // check title is empty
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a record title')),
      );

      return;
    }

    try {
      // add record to database
      await vaultRepository.addItem(
        userId: widget.userId,
        title: title,
        category: selectedCategory.dbValue,
        secretValue: secretValue,
        description: description,
        isFavorite: false,
      );

      // go back and refresh dashbord
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // show error when save fail
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

      // top bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
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

      // listview make screen can scroll
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // category input
                buildLabel('Category'),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<RecordCategory>(
                      value: selectedCategory,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textMuted,
                      ),

                      // make dropdown from enum
                      items: RecordCategory.values.map((category) {
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

                      // change category
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // title input
                buildLabel('Record Title'),

                const SizedBox(height: 8),

                buildTextField(
                  'Enter title (e.g. Netflix Primary)',
                  controller: titleController,
                ),

                const SizedBox(height: 24),

                // secret label and show hide button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildLabel('Sensitive Information'),

                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // change hide and show
                          isHidden = !isHidden;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            isHidden
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 14,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            isHidden ? 'Show' : 'Hide',
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

                // secret input box
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
                        controller: secretController,

                        // one line when secret hide
                        maxLines: isHidden ? 1 : null,

                        // hide or show secret text
                        obscureText: isHidden,

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

                      // paste icon
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
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

                // description input
                Row(
                  children: [
                    const Icon(
                      Icons.sort,
                      size: 14,
                      color: AppColors.textMuted,
                    ),

                    const SizedBox(width: 4),

                    buildLabel('Description (Optional)'),
                  ],
                ),

                const SizedBox(height: 8),

                buildTextField(
                  'Add any notes here...',
                  controller: descriptionController,
                ),

                const SizedBox(height: 32),

                // save button
                CustomButton(
                  text: 'Save Record',
                  backgroundColor: AppColors.textDark,
                  onPressed: saveRecord,
                ),

                const SizedBox(height: 12),

                // cancel button
                CustomButton(
                  text: 'Cancel',
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.textMuted,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
