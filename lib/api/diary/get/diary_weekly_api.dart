import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/diary/models/diary_weekly.dart';

// 일주일치 일기 조회 (메인페이지용)
class DiaryWeeklyApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/weekly');

  Future<List<DiaryWeekly>> getDiaryWeekly({required int petId}) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {'petId': petId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('DiaryWeeklyApi 응답: ${response.data}');

      // 응답 데이터가 Map인 경우 content 필드 확인
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('content') && data['content'] is List) {
          return (data['content'] as List)
              .map((json) => DiaryWeekly.fromJson(json))
              .toList();
        } else {
          // 빈 리스트 반환
          return [];
        }
      }

      // 응답 데이터가 List인 경우
      if (response.data is List) {
        return (response.data as List)
            .map((json) => DiaryWeekly.fromJson(json))
            .toList();
      }

      // 예상하지 못한 응답 형태
      print('예상하지 못한 응답 형태: ${response.data.runtimeType}');
      return [];
    } catch (e) {
      print('DiaryWeeklyApi 오류: $e');
      throw Exception('일주일 일기 불러오기 실패: $e');
    }
  }
}
