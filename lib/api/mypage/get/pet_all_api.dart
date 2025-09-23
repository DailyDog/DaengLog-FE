import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/mypage/models/pet_all_item.dart';

class PetAllApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<List<PetAllItem>> getAll() async {
    final res = await _dio.get('/all');
    final data = res.data as List<dynamic>;
    return data.map((e) => PetAllItem.fromJson(e as Map<String, dynamic>)).toList();
  }
}