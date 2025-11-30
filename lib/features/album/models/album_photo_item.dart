class AlbumPhotoItem {
  final int id;
  final String? imageUrl;
  final String category;
  final int count;

  AlbumPhotoItem({
    required this.id,
    this.imageUrl,
    required this.category,
    required this.count,
  });

  factory AlbumPhotoItem.fromJson(Map<String, dynamic> json) {
    return AlbumPhotoItem(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'category': category,
      'count': count,
    };
  }
}

