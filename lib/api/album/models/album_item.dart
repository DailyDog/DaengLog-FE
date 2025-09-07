// 앨범 전체 조회 아이템
class AlbumItem {
  final int albumId;
  final String name;
  final int imageCount;
  final String? thumbnailImageUrl;

  AlbumItem({
    required this.albumId,
    required this.name,
    required this.imageCount,
    required this.thumbnailImageUrl,
  });

  factory AlbumItem.fromJson(Map<String, dynamic> json) {
    return AlbumItem(
      albumId: json['albumId'] as int,
      name: json['name'] as String,
      imageCount: json['imageCount'] as int,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
    );
  }
}


