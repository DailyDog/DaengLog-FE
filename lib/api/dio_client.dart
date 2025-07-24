import 'package:dio/dio.dart';
import '../utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 토큰 갱신 함수
Future<String?> refreshAccessToken(String refreshToken) async {
  try {
    final dio = Dio();
    final response = await dio.post(
      '${dotenv.env['API_URL']!}/api/v1/token/refresh',
      data: {'refreshToken': refreshToken},
    );
    final data = response.data;
    final newAccessToken = data['accessToken'];
    await SecureTokenStorage.saveToken(newAccessToken);
    return newAccessToken;
  } catch (e) {
    return null;
  }
}

// 인증 토큰 추가 함수
Dio getDioWithAuth() {
  final dio = Dio();

  // 인증 토큰 추가
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureTokenStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },

    // 401 에러 시 토큰 갱신 시도
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        final refreshToken = await SecureTokenStorage.getRefreshToken();
        if (refreshToken != null) {
          try {
            final newToken = await refreshAccessToken(refreshToken);
            if (newToken != null) {
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final response = await dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            }
          } catch (e) {
            print('Token refresh failed: $e');
            // 로그인 화면 이동 처리 필요시 여기서 수행
          }
        }
      }
      handler.next(error);
    },
  ));

  return dio;
}

