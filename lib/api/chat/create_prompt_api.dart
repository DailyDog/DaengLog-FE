import 'dart:io';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';
import 'package:daenglog_fe/api/dio_client.dart';

class CreatePromptApi {
  final Dio _dio = Dio();
  
  // 요청 취소 토큰
  CancelToken? _cancelToken;

  final String _baseUrl = '${dotenv.env['API_URL']!}/api/v1/diary/preview';

  /// API 요청을 중단합니다.
  void cancelRequest() {
    _cancelToken?.cancel('Request cancelled by user');
  }

  Future<GptResponse?> createPrompt({required String prompt, required int? petId, required File imageFile}) async {
    // 새로운 CancelToken 생성
    _cancelToken = CancelToken();
    
    try {
      // 토큰 값 가져오기
      String? token = await SecureTokenStorage.getToken();
      
      // URL 파라미터 설정
      final Map<String, dynamic> queryParams = {
        'prompt': prompt,
        // 토큰이 있을 때만 petId 추가
        if (token != null && token.isNotEmpty) 'petId': petId,
      };

      // FormData에는 image만 포함
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path),
      });

      // 요청 정보 로그 출력
      print('Request URL: $_baseUrl');
      print('Query Parameters: $queryParams');
      print('Token: $token'); // 토큰 값 직접 출력
      print('Headers: ${token != null && token.isNotEmpty ? 'Bearer $token' : 'No token'}');
      print('Image file path: ${imageFile.path}');
      final response = await _dio.post(
        _baseUrl,
        queryParameters: queryParams,
        data: formData,
        options: Options(
          headers: {
            'Authorization': token != null && token.isNotEmpty ? 'Bearer $token' : null,
            // FormData 사용 시 Content-Type은 자동으로 설정됨
          },
        ),
        cancelToken: _cancelToken,
      );

      print(response.data);
      return GptResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return null;
      }
      // 401 에러 시 토큰 갱신 시도
      if (e is DioException && e.response?.statusCode == 500) {
        final refreshToken = await SecureTokenStorage.getRefreshToken();
        if (refreshToken != null) {
          try {
            // 토큰 갱신 (dio_client.dart의 함수 사용)
            final newToken = await refreshAccessToken(refreshToken);
            if (newToken != null) {
              // 새로운 토큰으로 재요청
              return await createPrompt(prompt: prompt, petId: petId, imageFile: imageFile);
            }
          } catch (refreshError) {
            print('Token refresh failed: $refreshError');
          }
        }
      }
      
      throw Exception('앨범 불러오기 실패: $e');
    }
  }
}