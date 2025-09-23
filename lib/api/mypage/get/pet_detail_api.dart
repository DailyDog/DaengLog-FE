import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetDetailApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<Map<String, dynamic>> getPetDetail(int petId) async {
    try {
      final res = await _dio.get('/$petId', options: Options(headers: {'Content-Type': 'application/json'}));
      return res.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('반려동물 상세 불러오기 실패: $e');
    }
  }
}


