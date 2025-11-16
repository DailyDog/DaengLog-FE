import 'package:flutter/material.dart';
import 'photo_screen_provider.dart';

/// chat_photo 패키지 내에서만 사용되는 Provider 관리자
class PhotoProviderManager {
  static PhotoScreenProvider? _instance;

  /// Provider 인스턴스 가져오기 (패키지 내부에서만 사용)
  static PhotoScreenProvider getInstance() {
    _instance ??= PhotoScreenProvider();
    return _instance!;
  }

  /// Provider 초기화 (화면 종료 시 호출)
  static void dispose() {
    _instance?.dispose();
    _instance = null;
  }

  /// Provider가 이미 생성되었는지 확인
  static bool get hasInstance => _instance != null;
}

/// chat_photo 패키지 내에서 사용할 수 있는 Provider 위젯
class PhotoProviderScope extends StatelessWidget {
  final Widget child;

  const PhotoProviderScope({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // 전역으로 제공되는 PhotoScreenProvider를 그대로 사용
    return child;
  }
}
