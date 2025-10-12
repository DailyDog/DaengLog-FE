import 'package:daenglog_fe/api/social_login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Center(
                child: Image.asset(
                  'assets/images/login/login_logo.png',
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(height: 24),
              const SizedBox(height: 60),
              _socialButton(
                icon: Image.asset('assets/images/login/google_icon.png',
                    width: 24),
                text: '구글로 시작하기    ',
                onTap: () async {
                  // 구글 로그인 및 서버 인증 (통합)
                  final result = await performGoogleLogin();
                  // 기존 사용자는 홈 메인 화면으로
                  context.go('/home');
                },
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/kakao_icon.png',
                    width: 24),
                text: '카카오로 시작하기',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/naver_icon.png',
                    width: 24),
                text: '네이버로 시작하기',
                onTap: () {},
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/apple_icon.png',
                    width: 24),
                text: '애플로 시작하기    ',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _socialButton({
    required Widget icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
