import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/diary/models/diary_monthly_calendar_model.dart';

// 월별 일기 조회 (캘린더용)
class DiaryMonthlyCalendarApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/monthly-calendar');

  Future<DiaryMonthlyCalendarModel> getDiaryMonthlyCalendar({required int? petId, required int? year, required int? month}) async {
    
    final response = await _dio.get(
      '', 
      queryParameters: {
        'petId': petId,
        'year': year,
        'month': month
        }
    );

      final data = response.data as Map<String, dynamic>;
      final model = DiaryMonthlyCalendarModel.fromJson(data);
      print(model);
      return model;
  }
}