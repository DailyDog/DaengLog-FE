import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/comming_soon/category.dart';
import 'package:daenglog_fe/api/dio_client.dart';

// 반려동물별 앨범 목록 조회
class CategoryApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<List<Category>> getCategory() async {
    try {
      final response = await _dio.get(
        '',
      );

      // 응답 데이터 파싱 리스트로 변환
      return (response.data as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('카테고리 불러오기 실패: $e');
    }
  }
}