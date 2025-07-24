import 'package:dio/dio.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

// 구글 로그인 인스턴스
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
);

// 구글 로그인 및 서버 인증 (통합)
Future<bool> performGoogleLogin() async {
  // 1. 구글 로그인
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) {
    return false; // 사용자가 로그인 취소
  }
  
  // 2. 구글 인증 정보 가져오기
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final idToken = googleAuth.idToken;
  
  if (idToken == null) {
    return false;
  }
  
  // 3. 서버에 idToken 전달하여 자체 토큰 발급
  try {
    final dio = Dio();
    final baseUrl = '${dotenv.env['API_URL']!}/api/v1/token/google';
      
    final response = await dio.post(
      baseUrl,
      queryParameters: {
        'idToken': idToken
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    
    final data = response.data;
    final accessToken = data['accessToken'];
    final refreshToken = data['refreshToken'];

    // 4. 토큰 저장
    await SecureTokenStorage.saveToken(accessToken);
    await SecureTokenStorage.saveRefreshToken(refreshToken);
    
    return true; // 로그인 성공
  } catch (e) {
    print('Login failed: $e');
    return false; // 로그인 실패
  }
}

// Oauth2 토큰 로그 출력 함수
void printLongString(String? text) {
  if (text == null) {
    return;
  }
  final pattern = RegExp('.{1,800}');
  for (final match in pattern.allMatches(text)) {
    print(match.group(0));
  }
}
