import 'package:dio/dio.dart';
import 'package:daenglog_fe/api/album/models/album_category.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 반려동물별 앨범 목록 조회
class AlbumCategoryApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<List<AlbumCategory>> getAlbumCategory() async {
    try {
      final response = await _dio.get(
        '',
      );

      // 응답 데이터 파싱 리스트로 변환
      return (response.data as List)
          .map((json) => AlbumCategory.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('카테고리 불러오기 실패: $e');
    }
  }
}