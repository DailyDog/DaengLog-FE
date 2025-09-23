import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetImageUpdateApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<String?> updatePetImage(int petId, XFile imageFile) async {
    print('🔵 PetImageUpdateApi.updatePetImage 시작');
    print('🔵 petId: $petId, 파일경로: ${imageFile.path}');

    try {
      print('🔵 FormData 생성 시작');
      final formData = FormData.fromMap({
        'profileImage': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });
      print('🔵 FormData 생성 완료');

      print('🔵 API 호출 시작: PATCH /$petId/image');
      final response = await _dio.patch(
        '/$petId/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print('🔵 API 응답 받음: ${response.statusCode}');
      print('🔵 응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final imageUrl = data['imageUrl'] as String?;
        print('🟢 이미지 URL 추출: $imageUrl');
        return imageUrl;
      }
      print('🔴 응답 상태 코드가 200이 아님: ${response.statusCode}');
      return null;
    } catch (e) {
      print('🔴 PetImageUpdateApi 에러: $e');
      if (e is DioException) {
        print(
            '🔴 DioException 상세: ${e.response?.statusCode} - ${e.response?.data}');
      }
      return null;
    }
  }
}
