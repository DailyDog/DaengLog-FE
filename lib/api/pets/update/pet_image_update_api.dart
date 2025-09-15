import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetImageUpdateApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<String?> updatePetImage(int petId, XFile imageFile) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      final response = await _dio.patch(
        '/$petId/image',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['imageUrl'] as String?;
      }
      return null;
    } catch (e) {
      print('🔴 프로필 이미지 업데이트 실패: $e');
      return null;
    }
  }
}