import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetImageUploadApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<void> upload({required int petId, required XFile image}) async {
    final formData = FormData();
    formData.files.add(
      MapEntry(
        'profileImage',
        await MultipartFile.fromFile(image.path, filename: image.name),
      ),
    );

    try {
      await _dio.patch(
        '/$petId/image',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dio.post(
          '/$petId/image',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        );
      } else {
        rethrow;
      }
    }
  }
}



