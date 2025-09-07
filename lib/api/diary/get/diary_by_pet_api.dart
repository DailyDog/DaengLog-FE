import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:daenglog_fe/api/diary/models/diary_by_pet.dart';

// 반려견별 일기 조회
class DiaryByPetApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/pet');

  Future<List<DiaryByPet>> getDiaryByPet({required int petId}) async {
    try {
      final response = await _dio.get('/$petId');

      final data = response.data;
      if (data is List) {
        print(data);
        return data
            .map((e) => DiaryByPet.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (data is Map<String, dynamic> && data['content'] is List) {
        return (data['content'] as List)
            .map((e) => DiaryByPet.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <DiaryByPet>[];
    } catch (e) {
      throw Exception('반려견 일기 조회 실패: $e');
    }
  }
}


