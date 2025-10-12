import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 앨범 생성
class AlbumCreateApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<Map<String, dynamic>> createAlbum(String name) async {
    try {
      final response = await _dio.post('', data: {
        'name': name,
      });
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('앨범 생성 실패: $e');
    }
  }
}
