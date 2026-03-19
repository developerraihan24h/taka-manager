class Category {
  final int? id;
  final String categoryName;
  final String shortDescription;
  final String type; // income / expense

  Category({
    this.id,
    required this.categoryName,
    required this.shortDescription,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_name': categoryName,
      'short_description': shortDescription,
      'type': type,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      categoryName: map['category_name'],
      shortDescription: map['short_description'],
      type: map['type'],
    );
  }
}
