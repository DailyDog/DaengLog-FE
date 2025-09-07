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
    try {
      await _dio.post(
        '/$petId',
        data: {
          'name': name,
          'birthday': birthday,
          'gender': gender,
          'species': species,
          'personalities': personalities,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw Exception('반려동물 수정 실패: $e');
    }
  }
}


