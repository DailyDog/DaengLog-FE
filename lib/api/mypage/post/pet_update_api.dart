import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetUpdateApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<void> updatePet({
    required int petId,
    required String name,
    required String birthday,
    required String gender,
    required String species,
    required List<String> personalities,
  }) async {
    final payload = {
      'name': name,
      'birthday': birthday,
      'gender': gender,
      'species': species,
      'personalities': personalities,
    };

    final headers = Options(headers: {'Content-Type': 'application/json'});

    // Some environments accept PATCH, others POST. Try PATCH → POST → PUT.
    try {
      await _dio.request(
        '/$petId',
        data: payload,
        options: headers.copyWith(method: 'PATCH'),
      );
      return;
    } on DioException catch (e) {
      if (e.response?.statusCode != 405) {
        throw Exception('반려동물 수정 실패: $e');
      }
    }

    try {
      await _dio.request(
        '/$petId',
        data: payload,
        options: headers.copyWith(method: 'POST'),
      );
      return;
    } on DioException catch (e) {
      if (e.response?.statusCode != 405) {
        throw Exception('반려동물 수정 실패: $e');
      }
    }

    try {
      await _dio.request(
        '/$petId',
        data: payload,
        options: headers.copyWith(method: 'PUT'),
      );
    } catch (e) {
      throw Exception('반려동물 수정 실패: $e');
    }
  }
}


