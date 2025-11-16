import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';

// Providers
import 'shared/services/default_profile_provider.dart';
import 'features/record/providers/record_provider.dart';
import 'features/cloud/providers/cloud_screen_provider.dart';
import 'features/pet_info/providers/pet_info_provider.dart';
import 'shared/services/pet_profile_provider.dart';
import 'features/weather/providers/weather_provider.dart';
import 'features/chat_photo/providers/photo_screen_provider.dart';

// Screens
import 'features/login/login.dart';
import 'features/splash/splash.dart';
import 'features/onboding/screens/onboding_start.dart';
import 'features/onboding/screens/onboding_main.dart';
import 'features/onboding/screens/onboding_sec.dart';
import 'features/onboding/screens/onboding_trd.dart';
import 'features/onboding/screens/onboding_fth.dart';

import 'features/homeScreen/screens/home_main_screen.dart';
import 'features/record/screens/record_main_screen.dart';
import 'features/record/screens/album_more_screen.dart';
import 'features/cloud/screens/cloud_main_screen.dart';
import 'features/mypage/screens/mypage_main_screen.dart';

// Additional screens
import 'features/chat/screens/chat_main_prompt_screen.dart';
import 'features/chat/screens/chat_communication_screen.dart';
import 'features/chat/screens/chat_history_screen.dart';
import 'features/chat_photo/screens/chat_photo_screen.dart';
import 'features/cloud_upload/screens/cloud_upload_screen.dart';
import 'features/pet_info/screens/pet_info_screen.dart';
import 'features/pet_info/screens/pet_info_kind_screen.dart';
import 'features/pet_info/screens/pet_info_name_screen.dart';
import 'features/pet_info/screens/pet_info_character_screen.dart';
import 'features/pet_info/screens/pet_info_profile_screen.dart';
import 'features/pet_detail/screens/pet_detail_screen.dart';
import 'features/pet_detail/screens/pet_basic_edit_screen.dart';
import 'features/pet_detail/screens/pet_personality_edit_screen.dart';
// import 'features/family_share/screens/family_share_screen.dart';
// import 'features/family_share/screens/family_send_screen.dart';
// import 'features/family_share/screens/envelope_receive_screen.dart';
import 'features/mypage/screens/mypage_my_info_screen.dart';
import 'features/mypage/screens/mypage_alarm_screen.dart';
import 'features/purchase/close.dart';
import 'features/weather/screens/weather_screen.dart';

// 페이지 이동 시 애니메이션 제거
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  NoTransitionPage({required Widget child})
      : super(
          child: child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DefaultProfileProvider()),
        ChangeNotifierProvider(create: (_) => RecordProvider()),
        ChangeNotifierProvider(create: (_) => CloudScreenProvider()),
        ChangeNotifierProvider(create: (_) => PetInfoProvider()),
        ChangeNotifierProvider(create: (_) => PetProfileProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => PhotoScreenProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/login',
      routes: [
        // 로그인/온보딩/스플래시 - ShellRoute 밖
        GoRoute(path: '/splash', builder: (context, state) => const Splash()),
        GoRoute(
            path: '/login',
            builder: (context, state) => const SocialLoginScreen()),
        GoRoute(
            path: '/onboding_start',
            builder: (context, state) => const OnbodingStart()),
        GoRoute(
            path: '/onboding_main',
            builder: (context, state) => const OnbodingMain()),
        GoRoute(
            path: '/onboding_sec',
            builder: (context, state) => const OnbodingSec()),
        GoRoute(
            path: '/onboding_trd',
            builder: (context, state) => const OnbodingTrd()),
        GoRoute(
            path: '/onboding_fth',
            builder: (context, state) => const OnbodingFth()),

        // Additional routes
        GoRoute(
            path: '/chat_main_prompt',
            builder: (context, state) => const ChatMainPromptScreen()),
        GoRoute(
            path: '/chat_communication',
            builder: (context, state) => const ChatCommunicationScreen()),
        GoRoute(
            path: '/chat_history',
            builder: (context, state) => const ChatHistoryScreen()),
        GoRoute(
            path: '/chat_photo',
            builder: (context, state) => const ChatPhotoScreen()),
        GoRoute(
            path: '/cloud_upload',
            builder: (context, state) => const CloudUploadScreen()),
        GoRoute(
            path: '/pet_info', builder: (context, state) => PetInfoScreen()),
        GoRoute(
            path: '/pet_information_kind',
            builder: (context, state) => const PetInformationKindScreen()),
        GoRoute(
            path: '/pet_information_name',
            builder: (context, state) => const PetInformationNameScreen()),
        GoRoute(
            path: '/pet_information_character',
            builder: (context, state) => PetInformationCharacterScreen()),
        GoRoute(
            path: '/pet_information_profile',
            builder: (context, state) => PetInformationProfileScreen()),
        GoRoute(
            path: '/pet_detail',
            builder: (context, state) => const PetDetailScreen()),
        GoRoute(
            path: '/pet_basic_edit',
            builder: (context, state) => const PetBasicEditScreen()),
        GoRoute(
            path: '/pet_personality_edit',
            builder: (context, state) => const PetPersonalityEditScreen()),
        // GoRoute(path: '/family_share', builder: (context, state) => const FamilyShareScreen()),
        // GoRoute(path: '/family_send', builder: (context, state) => const FamilySendScreen()),
        // GoRoute(path: '/envelope_receive', builder: (context, state) => const EnvelopeReceiveScreen()),
        GoRoute(
            path: '/my_info', builder: (context, state) => const MyInfoPage()),
        GoRoute(
            path: '/alarm_page',
            builder: (context, state) => const AlarmPage()),
        GoRoute(path: '/close', builder: (context, state) => const Close()),
        GoRoute(
            path: '/weather',
            builder: (context, state) => const WeatherScreen()),

        // 메인 탭 구조 - 하단바 고정
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const HomeMainScreen())),
            GoRoute(
                path: '/record',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const RecordMainScreen())),
            GoRoute(
                path: '/cloud',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const CloudMainScreen())),
            GoRoute(
                path: '/mypage',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: const MyPageMainScreen())),

            // Album and diary routes (inside ShellRoute for proper navigation)
            GoRoute(
                path: '/album-more',
                pageBuilder: (context, state) =>
                    MaterialPage(child: const AlbumMoreScreen())),
            GoRoute(
                path: '/album-detail/:albumId',
                pageBuilder: (context, state) => MaterialPage(
                    child: const SizedBox())), // TODO: Album detail screen
            GoRoute(
                path: '/diary-detail/:diaryId',
                pageBuilder: (context, state) => MaterialPage(
                    child: const SizedBox())), // TODO: Diary detail screen
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}

// 하단바 고정 레이아웃
class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  static const tabs = ['/home', '/record', '/cloud', '/mypage', '/mypage'];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 카메라 권한 확인
    if (index == 2) {
      Provider.of<RecordProvider>(context, listen: false)
          .takePhotoWithCamera(context);
    }
    // 라우터 이동
    else {
      context.go(tabs[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
