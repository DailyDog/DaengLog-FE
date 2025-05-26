// main.dart
import 'package:flutter/material.dart';

// 로그인 화면
import 'features/login/login.dart';

// 스플래시 화면
import 'features/splash/splash.dart';

// 온보딩 화면
import 'features/onboding/onboding_start.dart';
import 'features/onboding/onboding_first.dart';
import 'features/onboding/onboding_sec.dart';
import 'features/onboding/onboding_thr.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 초기 라우트 설정 = 초기 화면
      initialRoute: '/onboding',
      // routes 추가
      routes: {
        '/': (context) => const Splash(),
        '/onboding': (context) => const OnbodingStart(),
        '/onboding_first': (context) => const OnbodingFirst(),
        '/onboding_sec': (context) => const OnbodingSec(),
        '/onboding_thr': (context) => const OnbodingThr(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
