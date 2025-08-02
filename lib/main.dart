// main.dart
import 'package:daenglog_fe/features/collect_info/pet_info.dart';
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
import 'features/collect_info/pet_info.dart';
import 'features/collect_info/loading_screen.dart';

// 채팅 화면
import 'features/chat/home_prompt.dart';
import 'features/chat/chat_service.dart';
import 'features/chat_photo/chat_photo.dart';

// 가족 공유 화면
import 'features/family_share/send/family_share_share.dart';
import 'features/family_share/send/family_send.dart';
import 'features/family_share/receive/envelope_receive.dart';

// 홈스크린 화면
import 'features/homeScreen/home_main.dart';

// 마이페이지 화면
import 'features/mypage/my_page.dart';
import 'features/mypage/my_info_page.dart';
import 'features/mypage/alarm_page.dart';

// 마켓 화면 -> 임시 대표화면
import 'features/purchase/close.dart';


// 메인 함수
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  runApp(
    ChangeNotifierProvider( // 기본 프로필 정보 제공
      create: (_) => DefaultProfile(),
      child: const MyApp(), // 앱 실행
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 메타데이터 제공
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      // 초기 라우트 설정 = 초기 화면
      initialRoute: '/my_page', // 초기 화면 설정
      // routes 추가
      routes: {
        // 초기 화면
        '/splash': (context) => const Splash(), // 스플래시 화면

        // 온보딩 화면
        '/onboding_start': (context) => const OnbodingStart(), // 온보딩 시작 화면
        '/onboding_main': (context) => const OnbodingMain(), // 온보딩 메인 화면
        '/onboding_sec': (context) => const OnbodingSec(), // 온보딩 세컨드 화면
        '/onboding_trd': (context) => const OnbodingTrd(), // 온보딩 세컨드 화면
        '/onboding_fth': (context) => const OnbodingFth(), // 온보딩 포트폴리오 화면

        // 로그인 화면
        '/login': (context) => const SocialLoginScreen(), // 로그인 화면

        // 정보 입력 화면
        '/pet_information_kind': (context) => PetInformationKind( // 반려동물 종류 화면
          onNext: (kind) {
            Navigator.pushNamed(context, '/pet_information_name', arguments: kind); // 반려동물 이름 화면으로 이동
          },
        ),
          '/pet_information_name': (context) => PetInformationName( // 반려동물 이름 화면
          onNext: (name, birthday, gender) {
            Navigator.pushNamed(context, '/pet_information_character', arguments: { // 반려동물 캐릭터 화면으로 이동
              'name': name,
              'birthday': birthday, 
              'gender': gender,
            });
          },
        ),
        '/pet_information_character': (context) => PetInformationCharacter( // 반려동물 캐릭터 화면
          onNext: (characters) {
            Navigator.pushNamed(context, '/pet_information_profile', arguments: { // 반려동물 프로필 화면으로 이동
              'characters': characters,
            });
          },
        ),
        '/pet_information_profile': (context) => PetInformationProfile( // 반려동물 프로필 화면
          onNext: (profileImage) {
            Navigator.pushNamed(context, '/loading_screen', arguments: { // 로딩 화면으로 이동
              'petProfileImage': profileImage,
            });
          },
        ),
        '/pet_info': (context) => PetInfoFlow(), // 반려동물 정보 화면
        '/loading_screen': (context) => LoadingScreen(), // 로딩 화면
        //'/loading_test': (context) => StepProgressAnimation(),

        // 홈 화면
        '/home_main': (context) => ChangeNotifierProvider( // 기본 프로필 정보 제공
          create: (_) => DefaultProfile(), // 기본 프로필 정보 제공
          child: const HomeMainScreen(), // 홈 화면
        ), 
        
        // 채팅 화면
        '/home_prompt': (context) => const HomePromptScreen(), // 홈 프롬프트 화면
        '/chat_service': (context) => ChatService(), // 채팅 서비스 화면

        // 포토카드 화면
        '/chat_photo': (context) => const ChatPhoto(), // 채팅 포토카드 화면

        // 가족 공유 화면
        '/family_share': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return FamilyShareScreen(
            sharedContent: args?['content'] ?? '공유할 내용이 없습니다.',
            sharedImagePath: args?['imagePath'],
          );
        },
        '/family_send': (context) => const FamilySendScreen(), // 가족 공유 화면
        '/envelope_receive': (context) => const EnvelopeReceiveScreen(), // 가족 공유 화면

        // 마켓 화면
        '/close': (context) => const Close(),  // 마켓화면 -> 해당 라우터로 홈, 기록, 마켓, 마이페이지 이동

        // 마이페이지 화면
        '/my_page': (context) => const MyPage(), // 마이페이지 화면
        '/my_info_page': (context) => const MyInfoPage(), // 마이페이지 화면
        '/alarm_page': (context) => const AlarmPage(), // 알림 화면
      },
      // 라우트 설정 종료
    );
  }
}
