import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 기본 반려동물 조회
class DefaultProfileApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  // 프로필 불러오기
  Future<DefaultProfile> getDefaultProfile() async {
    try {
      final response = await _dio.get(
        '',
      );

      // 응답 데이터 파싱 단일 객체로 변환
      print('API Response: ${response.data}'); // 디버깅용
      return DefaultProfile.fromJson(response.data);
    } catch (e) {
      print('API Error: $e'); // 디버깅용
      throw Exception('프로필 불러오기 실패: $e');
    }
  }
}