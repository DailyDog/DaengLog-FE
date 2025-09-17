import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

class PetImageRefreshApi {
  final Dio _dio = getDioWithAuth('api/v1/pet');

  Future<String?> refreshPetImageUrl(int petId) async {
    try {
      final response = await _dio.post('/pets/$petId/refresh-image');
      
      final imageUrl = response.data['imageUrl'] as String?;
      
      // 응답 검증
      if (imageUrl == null || imageUrl.isEmpty) {
        print("🔴 API에서 빈 이미지 URL 응답");
        return null;
      }
      
      // URI 형식 검증
      try {
        final uri = Uri.parse(imageUrl);
        if (!uri.hasScheme || uri.host.isEmpty) {
          print("🔴 API에서 잘못된 URI 형식 응답: $imageUrl");
          return null;
        }
      } catch (e) {
        print("🔴 API 응답 URI 파싱 실패: $imageUrl");
        return null;
      }
      
      print("🔄 API 이미지 URL 갱신 성공: $imageUrl");
      return imageUrl;
    } catch (e) {
      print("🔴 Pet image refresh API 실패: $e");
      return null;
    }
  }
}