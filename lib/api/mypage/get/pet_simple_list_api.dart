import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/mypage/models/pet_simple_item.dart';

class PetSimpleListApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<List<PetSimpleItem>> getMySimpleList() async {
    try {
      final response = await _dio.get(
        '/my-simple-list',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = response.data as List;
      return data.map((e) => PetSimpleItem.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('반려동물 목록 불러오기 실패: $e');
    }
  }
}


