import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/diary.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlbumDetailApi {
  final Dio _dio = Dio();

  final token = dotenv.env['TOKEN']!;
  final String _baseUrl = '${dotenv.env['API_URL']!}/api/v1/diary/album';

  Future<List<Diary>> getAlbumDetail({required String keyword}) async {
    try {
      //final String? token = await SecureTokenStorage.getToken(); // 비동기 호출

      final response = await _dio.get(
        _baseUrl,
        queryParameters: {'keyword': keyword},
        options: Options(
          headers: {
            //'Authorization': 'Bearer $token',
            // 토큰 임시 넣기
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return (response.data as List)
          .map((json) => Diary.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('앨범 불러오기 실패: $e');
    }
  }
}