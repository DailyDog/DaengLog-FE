class AlbumModel {
  final int albumId;
  final String name;
  final int imageCount;
  final String? thumbnailImageUrl;

  AlbumModel({
    required this.albumId,
    required this.name,
    required this.imageCount,
    this.thumbnailImageUrl,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      albumId: json['albumId'] as int,
      name: json['name'] as String,
      imageCount: json['imageCount'] as int,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'albumId': albumId,
      'name': name,
      'imageCount': imageCount,
      'thumbnailImageUrl': thumbnailImageUrl,
    };
  }
}
