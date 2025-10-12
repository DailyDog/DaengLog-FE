class AlbumPetModel {
  final int albumId;
  final String name;
  final int imageCount;
  final String thumbnailImageUrl;

  AlbumPetModel({
    required this.albumId,
    required this.name,
    required this.imageCount,
    required this.thumbnailImageUrl,
  });

  factory AlbumPetModel.fromJson(Map<String, dynamic> json) {
    return AlbumPetModel(
      albumId: json['albumId'] as int,
      name: json['name'] as String,
      imageCount: json['imageCount'] as int,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'albumId': albumId,
        'name': name,
        'imageCount': imageCount,
        'thumbnailImageUrl': thumbnailImageUrl,
      };

  @override
  String toString() => toJson().toString();
}
