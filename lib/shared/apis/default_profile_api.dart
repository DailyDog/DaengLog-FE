import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 기본 반려동물 조회
class DefaultProfileApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  // 프로필 불러오기
  Future<DefaultProfile> getDefaultProfile() async {
    Response? response;

    try {
      // 1차 시도: 디폴트 프로필 전용 엔드포인트
      try {
        response = await _dio.get('/default');
        print('✅ /default 엔드포인트 사용');
      } catch (e) {
        // 2차 시도: 일반 pet 목록 엔드포인트
        print('⚠️ /default 엔드포인트 실패, 일반 목록 조회로 폴백');
        response = await _dio.get('');
      }

      // 응답 데이터 파싱
      print('DefaultProfile API Response: ${response.data}');

      dynamic responseData = response.data;
      Map<String, dynamic> jsonData;

      if (responseData is List) {
        if (responseData.isEmpty) {
          throw Exception('프로필 데이터가 없습니다.');
        }

        // myPet이 true인 항목 찾기 (디폴트 프로필)
        List<dynamic> myPets = (responseData as List)
            .where((pet) => pet is Map<String, dynamic> && pet['myPet'] == true)
            .toList();

        if (myPets.isEmpty) {
          // myPet이 없으면 첫 번째 요소 사용 (fallback)
          print('⚠️ myPet=true인 프로필이 없습니다. 첫 번째 프로필을 사용합니다.');
          jsonData = responseData.first;
        } else {
          // myPet이 true인 항목 사용
          jsonData = myPets.first;
          print('✅ 디폴트 프로필 선택됨: ${jsonData['name']} (id: ${jsonData['id']})');
        }
      } else if (responseData is Map<String, dynamic>) {
        jsonData = responseData;
        print('✅ 단일 프로필 응답: ${jsonData['name']} (id: ${jsonData['id']})');
      } else {
        throw Exception('예상하지 못한 응답 형식: ${responseData.runtimeType}');
      }

      return DefaultProfile.fromJson(jsonData);
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('프로필 불러오기 실패: $e');
    }
  }
}
