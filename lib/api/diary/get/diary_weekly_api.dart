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

      // 응답 데이터가 Map인 경우, diaries 또는 content 필드 확인
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;

        // 1) 새 백엔드 구조: { diaries: [...], statistics: {...} }
        if (data.containsKey('diaries') && data['diaries'] is List) {
          return (data['diaries'] as List)
              .map((json) => DiaryWeekly.fromJson(json))
              .toList();
        }

        // 2) 기존 페이징 구조: { content: [...] }
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

  /// 통계(todayCount, weeklyCount)를 함께 가져오는 헬퍼
  Future<DiaryWeeklySummary> getDiaryWeeklySummary({required int petId}) async {
    final response = await _dio.get(
      '',
      queryParameters: {'petId': petId},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    List<DiaryWeekly> diaries = [];
    int todayCount = 0;
    int weeklyCount = 0;

    if (data.containsKey('diaries') && data['diaries'] is List) {
      diaries = (data['diaries'] as List)
          .map((json) => DiaryWeekly.fromJson(json))
          .toList();
      final stats = data['statistics'] as Map<String, dynamic>? ?? {};
      todayCount = (stats['todayCount'] as num?)?.toInt() ?? 0;
      weeklyCount = (stats['weeklyCount'] as num?)?.toInt() ?? 0;
    }

    return DiaryWeeklySummary(
      diaries: diaries,
      todayCount: todayCount,
      weeklyCount: weeklyCount,
    );
  }
}
