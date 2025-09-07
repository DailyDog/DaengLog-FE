import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetSetDefaultApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<void> setDefault(int petId) async {
    try {
      // 우선 PUT 시도
      await _dio.put(
        '/$petId/default',
        data: const {},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      // 서버가 PUT 미지원이면 PATCH로 재시도
      if (e.response?.statusCode == 405) {
        await _dio.patch(
          '/$petId/default',
          data: const {},
          options: Options(headers: {'Content-Type': 'application/json'}),
        );
        return;
      }
      rethrow;
    } catch (e) {
      throw Exception('대표 반려동물 설정 실패: $e');
    }
  }
}


