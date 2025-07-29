import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// 토큰 저장 클래스
class SecureTokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static final _storage = FlutterSecureStorage();

  // 토큰 저장
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  // 토큰 불러오기
  static Future<String?> getToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // 토큰 삭제 (로그아웃 등)
  static Future<void> clearToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  static Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
  }
}
