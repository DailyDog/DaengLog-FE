import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:image/image.dart' as img;

// 일기 생성 (이미지 첨부 및 프롬프트 입력)
class DiaryCreatePromptApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/preview');

  // 요청 취소 토큰
  CancelToken? _cancelToken;

  /// API 요청을 중단합니다.
  void cancelRequest() {
    _cancelToken?.cancel('요청이 취소되었습니다.');
  }

  Future<DiaryGptResponse?> diaryCreatePrompt(
      {required String prompt,
      required int? petId,
      required File imageFile}) async {
    // 새로운 CancelToken 생성
    _cancelToken = CancelToken();

    try {
      // URL 파라미터 설정
      final Map<String, dynamic> queryParams = {
        'prompt': prompt,
        if (petId != null) 'petId': petId,
      };

      // 이미지 압축
      final compressedBytes = await _compressImage(imageFile);
      print('📸 이미지 압축 완료: ${compressedBytes.length} bytes');

      // FormData에는 압축된 이미지 포함
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(
          compressedBytes,
          filename: 'diary_image.jpg',
        ),
      });

      // 요청 정보 로그 출력
      final response = await _dio.post(
        '',
        queryParameters: queryParams,
        data: formData,
        cancelToken: _cancelToken,
      );

      return DiaryGptResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return null;
      }

      print('일기 생성 API 오류: $e');
      throw Exception('일기 생성 실패: $e');
    }
  }

  // 이미지 압축 메서드
  Future<Uint8List> _compressImage(File imageFile) async {
    try {
      // 원본 이미지 읽기
      final bytes = await imageFile.readAsBytes();
      final originalSize = bytes.length;
      print('📸 원본 이미지 크기: ${originalSize} bytes');

      // 이미지 디코딩
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('이미지 디코딩 실패');
      }

      // 이미지 리사이징 (최대 800px로 제한)
      img.Image resizedImage = image;
      if (image.width > 800 || image.height > 800) {
        final ratio =
            800 / (image.width > image.height ? image.width : image.height);
        resizedImage = img.copyResize(
          image,
          width: (image.width * ratio).round(),
          height: (image.height * ratio).round(),
        );
        print(
            '📸 이미지 리사이징: ${image.width}x${image.height} → ${resizedImage.width}x${resizedImage.height}');
      }

      // JPEG로 인코딩 (품질 85%)
      final compressedBytes = img.encodeJpg(resizedImage, quality: 85);
      final compressedSize = compressedBytes.length;
      print(
          '📸 압축된 이미지 크기: ${compressedSize} bytes (${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)}% 감소)');

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      print('❌ 이미지 압축 실패: $e');
      // 압축 실패 시 원본 파일 반환
      return await imageFile.readAsBytes();
    }
  }
}
