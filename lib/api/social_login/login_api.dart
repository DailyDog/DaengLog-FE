import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 구글 로그인 인스턴스
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'profile',
  ],
);

// 구글 로그인 및 서버 인증 (통합)
Future<Map<String, dynamic>> performGoogleLogin() async {
  // 1. 구글 로그인
  final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  if (googleUser == null) {
    return {'success': false, 'isNewUser': false}; // 사용자가 로그인 취소
  }
  
  // 2. 구글 인증 정보 가져오기
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final idToken = googleAuth.idToken;
  
  if (idToken == null) {
    return {'success': false, 'isNewUser': false};
  }
  
  // 3. 서버에 idToken 전달하여 자체 토큰 발급
  try {
    final dio = Dio();
    final loginUrl = dotenv.env['LOGIN_API_URL']!;
      
    final response = await dio.post(
      loginUrl,
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
    await SecureTokenStorage.saveToken(accessToken); // 액세스 토큰 저장
    await SecureTokenStorage.saveRefreshToken(refreshToken); // 리프레시 토큰 저장
    
    // 5. 사용자 프로필 정보 확인 (기존 사용자인지 새로운 사용자인지 판단)
    bool isNewUser = true;
    try {
      final profileDio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_URL']!,
        headers: {'Authorization': 'Bearer $accessToken'},
      ));
      
      await profileDio.get('api/v1/pet/default');
      isNewUser = false; // 프로필 정보가 있으면 기존 사용자
    } catch (e) {
      // 404 에러 등으로 프로필이 없으면 새로운 사용자
      isNewUser = true;
    }
    
    return {'success': true, 'isNewUser': isNewUser}; // 로그인 성공
  } catch (e) {
    print('Login failed: $e');
    return {'success': false, 'isNewUser': false}; // 로그인 실패
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
