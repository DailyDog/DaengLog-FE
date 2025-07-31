// 카테고리 리스트
class Category {
  final int categoryId;
  final String categoryName;

  Category({required this.categoryId, required this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['id'],
      categoryName: json['name'],
    );
  }
}