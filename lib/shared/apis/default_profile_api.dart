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
      print('API Response 안녕: ${response.data}'); // 디버깅용
      
      // 응답이 List인 경우 첫 번째 요소 사용, Map인 경우 직접 사용
      dynamic responseData = response.data;
      Map<String, dynamic> jsonData;
      
      if (responseData is List) {
        if (responseData.isEmpty) {
          throw Exception('프로필 데이터가 없습니다.');
        }
        jsonData = responseData.first;
      } else if (responseData is Map<String, dynamic>) {
        jsonData = responseData;
      } else {
        throw Exception('예상하지 못한 응답 형식: ${responseData.runtimeType}');
      }
      
      return DefaultProfile.fromJson(jsonData);
    } catch (e) {
      print('API Error: $e'); // 디버깅용
      throw Exception('프로필 불러오기 실패: $e');
    }
  }
}