import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/album/models/album_item.dart';

// 반려동물별 앨범 목록 조회
class AlbumPetApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<List<AlbumItem>> getAlbumsByPet(int petId) async {
    try {
      final response = await _dio.get('/pet/$petId');
      final data = response.data;
      if (data is List) {
        return data
            .map((e) => AlbumItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <AlbumItem>[];
    } catch (e) {
      throw Exception('반려동물 앨범 조회 실패: $e');
    }
  }
}
