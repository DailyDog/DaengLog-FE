import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';

class MyPageSummaryApi {
  final Dio _dio = getDioWithAuth('api/v1/users');

  Future<MyPageSummary> getSummary() async {
    try {
      final response = await _dio.get(
        '/my-page-summary',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return MyPageSummary.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('마이페이지 요약 불러오기 실패: $e');
    }
  }
}


