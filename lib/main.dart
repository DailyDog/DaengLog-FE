// main.dart
import 'package:daenglog_fe/features/onboding/onboding_fth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/common/widgets/others/default_profile.dart';

// 로그인 화면
import 'features/login/login.dart';

// 스플래시 화면
import 'features/splash/splash.dart';

// 온보딩 화면
import 'features/onboding/onboding_start.dart';
import 'features/onboding/onboding_main.dart';
import 'features/onboding/onboding_sec.dart';
import 'features/onboding/onboding_trd.dart';

// 정보 입력 화면
import 'features/collect_info/pet_info_kind.dart';
import 'features/collect_info/pet_info_name.dart';
import 'features/collect_info/pet_info_character.dart';
import 'features/collect_info/pet_info_profile.dart';
//import 'features/collect_info/pet_info_photos.dart';

// 채팅 화면
import 'features/chat/home_prompt.dart';
import 'features/chat/chat_service.dart';
import 'features/chat_photo/chat_photo.dart';

// 홈스크린 화면
import 'features/homeScreen/home_main.dart';

// 기록 화면

// 마켓 화면 -> 임시 대표화면
import 'features/purchase/close.dart';

// 마이 화면

// 메인 함수
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (_) => DefaultProfile(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 초기 라우트 설정 = 초기 화면
      initialRoute: '/login',
      // routes 추가
      routes: {
        // 초기 화면
        '/splash': (context) => const Splash(),

        // 온보딩 화면
        '/onboding_start': (context) => const OnbodingStart(),
        '/onboding_main': (context) => const OnbodingMain(),
        '/onboding_sec': (context) => const OnbodingSec(),
        '/onboding_trd': (context) => const OnbodingTrd(),
        '/onboding_fth': (context) => const OnbodingFth(),

        // 로그인 화면
        '/login': (context) => const SocialLoginScreen(),

        // 정보 입력 화면
        '/pet_information_kind': (context) => const PetInformationKind(),
        '/pet_information_name': (context) => const PetInformationName(),
        '/pet_information_character': (context) => const PetInformationCharacter(),
        '/pet_information_profile': (context) => const PetInformationProfile(),
        //'/pet_information_photos': (context) => const PetInformationPhotos(),

        // 홈 화면
        '/home_main': (context) => ChangeNotifierProvider(
          create: (_) => DefaultProfile(),
          child: const HomeMainScreen(),
        ), 
        
        // 채팅 화면
        '/home_prompt': (context) => const HomePromptScreen(),
        '/chat_service': (context) => const ChatService(),

        // 포토카드 화면
        '/chat_photo': (context) => const ChatPhoto(),

        // 마켓 화면
        '/close': (context) => const Close(),  // 마켓화면 -> 해당 라우터로 홈, 기록, 마켓, 마이페이지 이동
      },
    );
  }
}
