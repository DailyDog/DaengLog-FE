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

      return (response.data as List)
          .map((json) => DiaryWeekly.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('앨범 불러오기 실패: $e');
    }
  }
} 