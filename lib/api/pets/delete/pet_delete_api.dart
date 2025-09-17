import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetDeleteApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<bool> deletePet(int petId) async {
    try {
      final response = await _dio.delete(
        '/$petId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('🔴 반려동물 삭제 실패: $e');
      return false;
    }
  }
}