import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/category.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:daenglog_fe/api/dio_client.dart';

class CategoryApi {
  final Dio _dio = getDioWithAuth();
  
  // 환경 변수 사용
  final String _baseUrl = '${dotenv.env['API_URL']!}/api/v1/albums';

  // 카테고리 불러오기
  Future<List<Category>> getCategory() async {
    try {
      final response = await _dio.get(
        _baseUrl, // 기본 URL
        options: Options( // 헤더 설정
          headers: {
            'Content-Type': 'application/json',
          },
        ),
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