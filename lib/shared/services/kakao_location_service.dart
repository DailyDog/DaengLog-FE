import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 위도/경도를 카카오 로컬 API(좌표 → 행정구역)로 조회해서
/// 시/도, 구/군, 동/읍/면 단위 주소를 가져오는 서비스.
class KakaoLocationService {
  KakaoLocationService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://dapi.kakao.com',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );

  final Dio _dio;

  String get _restApiKey {
    final key = dotenv.env['KAKAO_REST_API_KEY'] ?? '';
    if (key.isEmpty) {
      throw Exception('KAKAO_REST_API_KEY 가 .env에 설정되어 있지 않습니다.');
    }
    return key;
  }

  /// 위도/경도 기준으로 시/도, 구/군, 동/읍/면 정보를 조회
  ///
  /// Kakao 로컬 API: /v2/local/geo/coord2regioncode.json
  Future<KakaoRegion> getRegionFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        '/v2/local/geo/coord2regioncode.json',
        queryParameters: {
          'x': longitude, // Kakao: x=경도, y=위도
          'y': latitude,
        },
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $_restApiKey',
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;
      final documents = data['documents'] as List<dynamic>? ?? [];

      if (documents.isEmpty) {
        throw Exception('카카오 지역 정보가 없습니다.');
      }

      // 첫 번째 결과 사용
      final doc = documents.first as Map<String, dynamic>;

      return KakaoRegion(
        sido: doc['region_1depth_name'] as String? ?? '',
        gugun: doc['region_2depth_name'] as String? ?? '',
        dong: doc['region_3depth_name'] as String? ?? '',
      );
    } catch (e) {
      throw Exception('카카오 지역 정보 조회 실패: $e');
    }
  }
}

/// 시/도, 구/군, 동/읍/면 정보를 담는 단순 모델
class KakaoRegion {
  final String sido; // 예: 서울특별시
  final String gugun; // 예: 서초구
  final String dong; // 예: 서초동

  const KakaoRegion({
    required this.sido,
    required this.gugun,
    required this.dong,
  });

  @override
  String toString() => '$sido $gugun $dong';
}


