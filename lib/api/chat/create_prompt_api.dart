import 'dart:io';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';

class CreatePromptApi {
  final Dio _dio = Dio();

  final token = dotenv.env['TOKEN']!;
  final String _baseUrl = '${dotenv.env['API_URL']!}/api/v1/diary/preview';

  Future<GptResponse> createPrompt({required String prompt, required int petId, required File imageFile}) async {
    try {
      //final String? token = await SecureTokenStorage.getToken(); // 비동기 호출

      final response = await _dio.post(
        _baseUrl,
        queryParameters: {
          'prompt': prompt,
          'petId': petId,
        }, 
        options: Options(
          headers: {
            //'Authorization': 'Bearer $token',
            // 토큰 임시 넣기
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: FormData.fromMap({
          'image': await MultipartFile.fromFile(imageFile.path),
        }),
      );

      print(response.data);
      return GptResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('앨범 불러오기 실패: $e');
    }
  }
}