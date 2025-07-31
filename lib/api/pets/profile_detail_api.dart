import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/profile.dart';
import 'package:daenglog_fe/api/dio_client.dart';

// 기본 반려동물 조회
class ProfileDetailApi {
  final Dio _dio = getDioWithAuth('api/v1/pet/default');

  // 프로필 불러오기
  Future<Profile> getProfile() async {
    try {
      final response = await _dio.get(
        '',
      );

      // 응답 데이터 파싱 단일 객체로 변환
      print('API Response: ${response.data}'); // 디버깅용
      return Profile.fromJson(response.data);
    } catch (e) {
      print('API Error: $e'); // 디버깅용
      throw Exception('프로필 불러오기 실패: $e');
    }
  }
}