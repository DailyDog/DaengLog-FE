import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 토큰 갱신
Future<String?> refreshAccessToken(String refreshToken) async {
  try {
    print('[refreshAccessToken] 요청 시작 - refreshToken: $refreshToken');
    final refreshUrl = dotenv.env['REFRESH_API_URL']!;

    final dio = Dio();
    
    // 개발 환경(디버그 모드)에서만 SSL 인증서 검증 우회
    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true;
        };
        return client;
      };
    }

    final response = await dio.post(
      // 토큰 갱신 요청
      refreshUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      ),
      queryParameters: {'refreshToken': refreshToken}, // 리프레시 토큰 전달
    );
    print('refreshAccessToken response: ${response.data}');
    final data = response.data; // 토큰 갱신 응답 데이터
    final newAccessToken = data['accessToken'] as String?; // 새로운 액세스 토큰
    if (newAccessToken == null) return null;

    await SecureTokenStorage.saveToken(newAccessToken); // 새로운 액세스 토큰 저장
    return newAccessToken;
  } catch (_) {
    print('refreshAccessToken error: $_');
    return null;
  }
}

/// 인증 토큰 자동 부착 + 401 시 1회 재시도
Dio getDioWithAuth(String uri) {
  // 기본 요청 토큰 자동 부착 -> 특정 uri마다 붙이는 것은 따로 처리해야하는거 아닌가?
  final dio = Dio(BaseOptions(baseUrl: '${dotenv.env['API_URL']!}/$uri'));

  // 개발 환경(디버그 모드)에서만 SSL 인증서 검증 우회
  if (kDebugMode) {
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return client;
    };
  }

  // 동시 401 처리 방지용 (null이면 현재 갱신 중 아님)
  Future<String?>? _refreshing;

  // 인증 토큰 자동 부착
  dio.interceptors.add(QueuedInterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await SecureTokenStorage.getToken();
      print('[onRequest] 현재 accessToken: $token');
      print(
          '[onRequest] 현재 refreshToken: ${await SecureTokenStorage.getRefreshToken()}');

      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    // 401 에러 처리
    onError: (error, handler) async {
      final options = error.requestOptions;

      // 이미 재시도 된 요청이거나, 401이 아니면 패스
      if (options.extra['retried'] == true ||
          error.response?.statusCode != 401) {
        return handler.next(error);
      }

      // refresh 엔드포인트 자체의 실패면 패스(무한 루프 방지)
      if (options.path.endsWith(dotenv.env['REFRESH_API_URL']!)) {
        return handler.next(error);
      }

      try {
        // 동시성 제어: 이미 누군가 refresh 중이면 그 Future를 기다린다.
        if (_refreshing == null) {
          final refreshToken = await SecureTokenStorage.getRefreshToken();
          if (refreshToken == null) {
            await SecureTokenStorage.clear();
            return handler.next(error);
          }

          _refreshing = refreshAccessToken(refreshToken).whenComplete(() {
            // 토큰 갱신 요청 완료 후 참조 해제
            _refreshing = null;
          });
        }

        final newToken = await _refreshing;
        if (newToken == null) {
          await SecureTokenStorage.clear();
          return handler.next(error);
        }

        // 전역 헤더 갱신
        dio.options.headers['Authorization'] = 'Bearer $newToken';

        // 원 요청 재시도 (1회만)
        final newOptions = options.copyWith(
          headers: {
            ...options.headers,
            'Authorization': 'Bearer $newToken',
          },
          extra: {
            ...options.extra,
            'retried': true,
          },
          // dio v5의 copyWith는 data, queryParameters 등을 자동으로 복사해준다.
          // 필요 시 명시적으로 넘겨도 됨: data: options.data, queryParameters: options.queryParameters
        );

        final response = await dio.fetch(newOptions);
        return handler.resolve(response);
      } catch (_) {
        await SecureTokenStorage.clear();
        return handler.next(error);
      }
    },
  ));

  return dio;
}
