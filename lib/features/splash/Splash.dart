import 'package:flutter/material.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    final token = await SecureTokenStorage.getToken();
    await Future.delayed(const Duration(seconds: 1)); // 스플래시 1초 유지
    if (mounted) {
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home_main'); // 로그인 후 홈 메인 화면
      } else {
        Navigator.pushReplacementNamed(context, '/home_prompt'); // 로그인 전 홈 프롬프트 화면
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoWidth = size.width * 0.6;
    final logoHeight = size.height * 0.3;
    final logoSize = logoWidth < logoHeight ? logoWidth : logoHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash/entire.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
