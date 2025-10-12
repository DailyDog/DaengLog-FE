import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/diary/models/diary_detail.dart';

// 랜덤 일기 조회
class DiaryRandomApi {
  final Dio _dio = getDioWithAuth('api/v1/diary');

  Future<DiaryDetail?> getRandomDiary(int petId) async {
    try {
      // 먼저 반려동물의 일기 목록을 가져와서 랜덤하게 하나 선택
      final response = await _dio.get('/pet/$petId');
      final data = response.data;

      if (data is List && data.isNotEmpty) {
        // 랜덤하게 하나 선택
        final randomIndex =
            (DateTime.now().millisecondsSinceEpoch % data.length);
        final randomDiaryData = data[randomIndex] as Map<String, dynamic>;

        // 선택된 일기의 상세 정보를 가져옴
        final diaryId = randomDiaryData['id'] as int;
        final detailResponse = await _dio.get('/$diaryId');
        return DiaryDetail.fromJson(
            detailResponse.data as Map<String, dynamic>);
      }

      return null;
    } catch (e) {
      // 에러가 발생하면 null 반환 (일기가 없는 경우)
      return null;
    }
  }
}
