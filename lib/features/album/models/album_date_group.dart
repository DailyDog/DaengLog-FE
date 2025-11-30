import 'album_photo_item.dart';

/// 앨범 날짜별 그룹 데이터 모델
/// 
/// 특정 날짜에 속한 사진들을 그룹화한 데이터 모델입니다.
/// 날짜별 정렬 화면에서 사용됩니다.
class AlbumDateGroup {
  /// 날짜 문자열 (예: "2025.09.16")
  final String date;
  
  /// 해당 날짜에 속한 사진 리스트
  final List<AlbumPhotoItem> photos;

  AlbumDateGroup({
    required this.date,
    required this.photos,
  });

  /// JSON 데이터로부터 AlbumDateGroup 생성
  /// 
  /// API 응답을 파싱할 때 사용합니다.
  factory AlbumDateGroup.fromJson(Map<String, dynamic> json) {
    return AlbumDateGroup(
      date: json['date'] as String,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((photo) => AlbumPhotoItem.fromJson(photo as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// AlbumDateGroup을 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'photos': photos.map((photo) => photo.toJson()).toList(),
    };
  }
}

