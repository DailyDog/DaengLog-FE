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

// 정보 입력 화면
import 'features/collect_information/information_first.dart';
// import 'features/collect_information/information_sec.dart'

// 홈스크린 화면
import 'features/homeScreen/home_prompt.dart';
import 'features/homeScreen/home_main.dart';
import 'features/homeScreen/home_prompt_sec.dart';

// 기록 화면

// 마켓 화면 -> 임시 대표화면
import 'features/purchase/close.dart';

// 마이 화면


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
      initialRoute: '/home_prompt',
      // routes 추가
      routes: {
        // 초기 화면
        '/splash': (context) => const Splash(),

        // 온보딩 화면
        '/onboding': (context) => const OnbodingStart(),
        '/onboding_first': (context) => const OnbodingFirst(),
        '/onboding_sec': (context) => const OnbodingSec(),
        '/onboding_thr': (context) => const OnbodingThr(),

        // 로그인 화면
        '/login': (context) => const LoginPage(),

        // 정보 입력 화면
        '/information_first': (context) => const InformationFirst(),
        //'/information_sec': (context) => const InformationSec()

        // 홈 화면
        '/home_prompt': (context) => const HomePromptScreen(),
        '/home_main': (context) => const HomeMainScreen(), 
        '/home_prompt_sec': (context) => const HomePromptSec(),

        // 마켓 화면
        '/close': (context) => const Close(),  // 마켓화면 -> 해당 라우터로 홈, 기록, 마켓, 마이페이지 이동
      },
    );
  }
}
