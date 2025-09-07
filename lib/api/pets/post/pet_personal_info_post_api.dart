import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:dio/dio.dart';

import '../models/pets_personal_info_post_model.dart';


class PetPersonalInfoPostApi {
  final Dio _dio = getDioWithAuth('api/v1/pet/personal');

  Future<void> postPetPersonalInfo(PetsPersonalInfoPostModel petPersonalInfo) async {
    try {
      final formData = await petPersonalInfo.toFormData();
      await _dio.post(
        '',
        data: formData,
      );
    } catch (e) {
      throw Exception('Pet personal info post failed: $e');
    }
  }
  
}