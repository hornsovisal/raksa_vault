class VaultItem {
  final int? id;
  final String userId;
  final String title;
  final String category;
  final String secretValue;
  final String description;
  final bool isFavorite;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaultItem({
    this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.secretValue,
    required this.description,
    required this.isFavorite,
    required this.createdAt,
    required this.updatedAt,
  });
}
