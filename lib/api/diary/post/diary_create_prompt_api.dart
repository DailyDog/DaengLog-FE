import 'dart:io';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 일기 생성 (이미지 첨부 및 프롬프트 입력)
class DiaryCreatePromptApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/preview');

  // 요청 취소 토큰
  CancelToken? _cancelToken;

  /// API 요청을 중단합니다.
  void cancelRequest() {
    _cancelToken?.cancel('요청이 취소되었습니다.');
  }

  Future<DiaryGptResponse?> diaryCreatePrompt(
      {required String prompt,
      required int? petId,
      required File imageFile}) async {
    // 새로운 CancelToken 생성
    _cancelToken = CancelToken();

    try {
      // URL 파라미터 설정
      final Map<String, dynamic> queryParams = {
        'prompt': prompt,
        if (petId != null) 'petId': petId,
      };

      // FormData에는 image만 포함
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      // 요청 정보 로그 출력
      final response = await _dio.post(
        '',
        queryParameters: queryParams,
        data: formData,
        cancelToken: _cancelToken,
      );

      return DiaryGptResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return null;
      }

      print('일기 생성 API 오류: $e');
      throw Exception('일기 생성 실패: $e');
    }
  }
}
