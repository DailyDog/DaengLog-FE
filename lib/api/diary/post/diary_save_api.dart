import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/services/dio_client.dart';
import 'package:image/image.dart' as img;

// 일기 저장 응답 모델
class DiarySaveResponse {
  final int diaryId;
  final String title;
  final String content;
  final String keyword;
  final List<String> keywords;
  final int recordNumber;
  final String imageUrl;
  final String date;

  DiarySaveResponse({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.keyword,
    required this.keywords,
    required this.recordNumber,
    required this.imageUrl,
    required this.date,
  });

  factory DiarySaveResponse.fromJson(Map<String, dynamic> json) {
    return DiarySaveResponse(
      diaryId: json['diaryId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      keyword: json['keyword'] as String,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      recordNumber: json['recordNumber'] as int,
      imageUrl: json['imageUrl'] as String,
      date: json['date'] as String,
    );
  }
}

// 일기 저장 API
class DiarySaveApi {
  final Dio _dio = getDioWithAuth('api/v1/diary/save');

  Future<DiarySaveResponse> saveDiary({
    required String title,
    required String content,
    required String keyword,
    required int petId,
    required Uint8List imageBytes,
  }) async {
    try {
      print('📝 일기 저장 시작: title=$title, petId=$petId');

      // 이미지 압축
      final compressedBytes = await _compressImage(imageBytes);
      print('📸 이미지 압축 완료: ${compressedBytes.length} bytes');

      // FormData 생성
      final formData = FormData.fromMap({
        'title': title,
        'content': content,
        'keyword': keyword,
        'petId': petId.toString(),
        'decoratedImage': MultipartFile.fromBytes(
          compressedBytes,
          filename: 'diary_image.jpg',
        ),
      });

      final response = await _dio.post('', data: formData);

      if (response.statusCode == 200) {
        final result = DiarySaveResponse.fromJson(response.data);
        print('✅ 일기 저장 성공: diaryId=${result.diaryId}');
        return result;
      } else {
        throw Exception('일기 저장 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('일기 저장 실패: 잘못된 요청입니다');
      } else if (e.response?.statusCode == 401) {
        throw Exception('일기 저장 실패: 로그인이 필요합니다');
      } else if (e.response?.statusCode == 403) {
        throw Exception('일기 저장 실패: 권한이 없습니다');
      } else {
        throw Exception('일기 저장 실패: 네트워크 오류가 발생했습니다');
      }
    } catch (e) {
      print('❌ 일기 저장 오류: $e');
      throw Exception('일기 저장 실패: $e');
    }
  }

  // 이미지 압축 메서드
  Future<Uint8List> _compressImage(Uint8List imageBytes) async {
    try {
      final originalSize = imageBytes.length;
      print('📸 원본 이미지 크기: ${originalSize} bytes');

      // 이미지 디코딩
      final image = img.decodeImage(imageBytes);
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
      // 압축 실패 시 원본 반환
      return imageBytes;
    }
  }
}
