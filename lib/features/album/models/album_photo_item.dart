/// 앨범 사진 아이템 데이터 모델
/// 
/// 앨범에 포함된 개별 사진/일기의 정보를 담는 모델입니다.
/// API 응답 형식:
/// {
///   "id": 123,
///   "imageUrl": "https://...",
///   "title": "...",
///   "date": "2024-12-15",
///   "keywords": ["산책"],
///   ...
/// }
class AlbumPhotoItem {
  /// 사진/일기 ID
  final int id;
  
  /// 이미지 URL (일기의 대표 이미지)
  final String? imageUrl;
  
  /// 카테고리명 (앨범 이름과 동일, 예: "산책", "간식", "놀이")
  final String category;
  
  /// 카운트 (해당 카테고리의 사진 개수)
  final int count;

  AlbumPhotoItem({
    required this.id,
    this.imageUrl,
    required this.category,
    required this.count,
  });

  /// JSON 데이터로부터 AlbumPhotoItem 생성
  /// 
  /// API 응답을 파싱할 때 사용합니다.
  factory AlbumPhotoItem.fromJson(Map<String, dynamic> json) {
    return AlbumPhotoItem(
      id: json['id'] as int,
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String? ?? '', // 기본값: 빈 문자열
      count: json['count'] as int? ?? 0, // 기본값: 0
    );
  }

  /// AlbumPhotoItem을 JSON 형태로 변환
  /// 
  /// API 요청 시 사용할 수 있습니다.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'category': category,
      'count': count,
    };
  }
}

