import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 반려동물별 첫 일기 작성일 조회
class DiaryFirstDateApi {
  final Dio _dio = getDioWithAuth('api/v1/diary');

  Future<DateTime?> getFirstDiaryDate({required int petId}) async {
    try {
      final response = await _dio.get(
        '/first-date',
        queryParameters: {'petId': petId},
      );

      final data = response.data;
      if (data != null && data['firstDiaryDate'] != null) {
        return DateTime.parse(data['firstDiaryDate']);
      }
      return null;
    } catch (e) {
      debugPrint('첫 일기 작성일 조회 실패: $e');
      return null;
    }
  }
}
