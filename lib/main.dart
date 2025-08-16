// main.dart
import 'package:daenglog_fe/features/record/screens/record_main_screen.dart';
import 'package:daenglog_fe/features/record/screens/image_upload_screen.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_screen.dart';
import 'package:daenglog_fe/features/onboding/screens/onboding_fth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';

// 로그인 화면
import 'features/login/login.dart';

// 스플래시 화면
import 'features/splash/splash.dart';

// 온보딩 화면
import 'features/onboding/screens/onboding_start.dart';
import 'features/onboding/screens/onboding_main.dart';
import 'features/onboding/screens/onboding_sec.dart';
import 'features/onboding/screens/onboding_trd.dart';

// 정보 입력 화면
import 'features/pet_info/screens/pet_info_kind_screen.dart';
import 'features/pet_info/screens/pet_info_name_screen.dart';
import 'features/pet_info/screens/pet_info_character_screen.dart';
import 'features/pet_info/screens/pet_info_profile_screen.dart';
import 'features/pet_info/screens/pet_info_screen.dart';
import 'features/pet_info/screens/pet_info_loading_screen.dart';

// 채팅 화면
import 'features/chat/screens/chat_main_prompt_screen.dart';
import 'features/chat/screens/chat_communication_screen.dart';
import 'features/photo/screens/photo_screen.dart';

// 가족 공유 화면
import 'features/family_share/screens/family_share_share.dart';
import 'features/family_share/screens/family_send.dart';
import 'features/family_share/screens/envelope_receive.dart';

// 홈스크린 화면
import 'features/homeScreen/screens/home_main_screen.dart';

// 마이페이지 화면
import 'features/mypage/screens/mypage_main_screen.dart';
import 'features/mypage/screens/mypage_my_info_screen.dart';
import 'features/mypage/screens/mypage_alarm_screen.dart';

// 마켓 화면 -> 임시 대표화면
import 'features/purchase/close.dart';


// 메인 함수
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // .env 파일 로드
  runApp(
    // ChangeNotifierProvider( // 기본 프로필 정보 제공
    //   create: (_) => DefaultProfileProvider(),
    MultiProvider( // 여러 provider 제공
      providers: [
        ChangeNotifierProvider(create: (_) => DefaultProfileProvider()), // 기본 프로필 정보 제공
        ChangeNotifierProvider(create: (_) => RecordProvider()), // 기록 화면 제공 -> 나중에 전역 해제 특정 화면에서 사용
      ],
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
      initialRoute: '/record_main', // 초기 화면 설정
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
        '/pet_information_kind': (context) => PetInformationKindScreen( // 반려동물 종류 화면
          onNext: (kind) {
            Navigator.pushNamed(context, '/pet_information_name', arguments: kind); // 반려동물 이름 화면으로 이동
          },
        ),
          '/pet_information_name': (context) => PetInformationNameScreen( // 반려동물 이름 화면
          onNext: (name, birthday, gender) {
            Navigator.pushNamed(context, '/pet_information_character', arguments: { // 반려동물 캐릭터 화면으로 이동
              'name': name,
              'birthday': birthday, 
              'gender': gender,
            });
          },
        ),
        '/pet_information_character': (context) => PetInformationCharacterScreen( // 반려동물 캐릭터 화면
          onNext: (characters) {
            Navigator.pushNamed(context, '/pet_information_profile', arguments: { // 반려동물 프로필 화면으로 이동
              'characters': characters,
            });
          },
        ),
        '/pet_information_profile': (context) => PetInformationProfileScreen( // 반려동물 프로필 화면
          onNext: (profileImage) {
            Navigator.pushNamed(context, '/loading_screen', arguments: { // 로딩 화면으로 이동
              'petProfileImage': profileImage,
            });
          },
        ),
        '/pet_info': (context) => PetInfoScreen(), // 반려동물 정보 화면
        '/loading_screen': (context) => PetInfoLoadingScreen(), // 로딩 화면
        //'/loading_test': (context) => StepProgressAnimation(),

        // 홈 화면
        '/home_main': (context) => ChangeNotifierProvider( // 기본 프로필 정보 제공
          create: (_) => DefaultProfileProvider(), // 기본 프로필 정보 제공
          child: const HomeMainScreen(), // 홈 화면
        ), 
        
        // 채팅 화면
        '/chat_main_prompt': (context) => const ChatMainPromptScreen(), // 홈 프롬프트 화면
        '/chat_communication': (context) => ChatCommunicationScreen(), // 채팅 서비스 화면

        // 포토카드 화면
        '/photo': (context) => const PhotoScreen(), // 채팅 포토카드 화면

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
        '/my_page': (context) => const MyPageMainScreen(), // 마이페이지 화면
        '/my_info_page': (context) => const MyInfoPage(), // 마이페이지 화면
        '/alarm_page': (context) => const AlarmPage(), // 알림 화면

        // 기록 화면
        '/record_main': (context) => const RecordMainScreen(), // 기록 화면
        '/image_upload': (context) => const ImageUploadScreen(), // 이미지 업로드 화면
      },
      // 라우트 설정 종료
    );
  }
}
