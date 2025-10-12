import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';

// 앨범 생성
class AlbumCreateApi {
  final Dio _dio = getDioWithAuth('api/v1/albums');

  Future<Map<String, dynamic>> createAlbum(String name,
      {required int petId}) async {
    try {
      // 입력값 검증
      if (name.trim().isEmpty) {
        throw Exception('앨범 이름을 입력해주세요');
      }

      if (petId <= 0) {
        throw Exception('반려동물을 선택해주세요');
      }

      final requestData = {
        'name': name.trim(),
        'petId': petId.toString(),
      };

      final response = await _dio.post(
        '',
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('서버 응답 오류: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        String errorMessage = '잘못된 요청입니다';

        if (errorData is Map<String, dynamic>) {
          errorMessage =
              errorData['message'] ?? errorData['error'] ?? errorMessage;
        }

        throw Exception('앨범 생성 실패: $errorMessage');
      } else if (e.response?.statusCode == 409) {
        throw Exception('앨범 생성 실패: 이미 존재하는 앨범 이름입니다');
      } else if (e.response?.statusCode == 401) {
        throw Exception('앨범 생성 실패: 로그인이 필요합니다');
      } else if (e.response?.statusCode == 403) {
        throw Exception('앨범 생성 실패: 권한이 없습니다');
      } else {
        throw Exception('앨범 생성 실패: 네트워크 오류가 발생했습니다');
      }
    } catch (e) {
      throw Exception('앨범 생성 실패: $e');
    }
  }
}
