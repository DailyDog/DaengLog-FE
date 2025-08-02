// 카테고리 리스트
class AlbumCategory {
  final int categoryId;
  final String categoryName;

  AlbumCategory({required this.categoryId, required this.categoryName});

  factory AlbumCategory.fromJson(Map<String, dynamic> json) {
    return AlbumCategory(
      categoryId: json['id'],
      categoryName: json['name'],
    );
  }
}