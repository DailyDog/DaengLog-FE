import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/profile.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 디폴트 프로필 정보 가져오기
class ProfileDetailApi {
  final Dio _dio = Dio();
  final String _baseUrl = '${dotenv.env['API_URL']!}/api/v1/pet/default';
  final token = dotenv.env['TOKEN']!;

  // 프로필 불러오기
  Future<Profile> getProfile() async {
    try {
      //final String? token = await SecureTokenStorage.getToken();
      final response = await _dio.get(
        _baseUrl, // 기본 URL
        options: Options( // 헤더 설정
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
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