import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/album/models/album_item.dart';

// 앨범 전체 조회
class AlbumListApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<List<AlbumItem>> getAlbums() async {
    try {
      final response = await _dio.get('');
      final data = response.data;
      if (data is List) {
        print(data);
        return data.map((e) => AlbumItem.fromJson(e as Map<String, dynamic>)).toList();
      }
      if (data is Map<String, dynamic> && data['content'] is List) {
        return (data['content'] as List)
            .map((e) => AlbumItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <AlbumItem>[];
    } catch (e) {
      throw Exception('앨범 전체 조회 실패: $e');
    }
  }
}


