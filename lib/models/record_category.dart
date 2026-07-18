import 'package:flutter/material.dart';

// all record category
enum RecordCategory {
  passwords(
    displayName: 'Passwords',
    dbValue: 'Login',
    icon: Icons.lock_outline,
  ),

  bankAccounts(
    displayName: 'Bank Accounts',
    dbValue: 'Identity',
    icon: Icons.account_balance_outlined,
  ),

  cards(
    displayName: 'Cards',
    dbValue: 'Card',
    icon: Icons.credit_card_outlined,
  ),

  notes(displayName: 'Notes', dbValue: 'Note', icon: Icons.note_outlined),

  other(displayName: 'Other', dbValue: 'Other', icon: Icons.folder_outlined);

  // name show to user
  final String displayName;

  // value save to sqlite
  final String dbValue;

  // icon show in screen
  final IconData icon;

  const RecordCategory({
    required this.displayName,
    required this.dbValue,
    required this.icon,
  });

  // change sqlite string back to enum
  static RecordCategory fromDbValue(String value) {
    return RecordCategory.values.firstWhere(
      (category) => category.dbValue == value,
      orElse: () => RecordCategory.other,
    );
  }
}
