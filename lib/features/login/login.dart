import 'package:daenglog_fe/api/login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({Key? key}) : super(key: key);

  // 리다이렉션 URL
  static String redirectUrl = '${dotenv.env['API_URL']!}/oauth2/authorization/google';

  // 리다이렉션 함수
  void _redirect() async {
    final Uri url = Uri.parse(redirectUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                icon: Image.asset('assets/images/login/google_icon.png', width: 24),
                text: '구글로 시작하기    ',
                onTap: () async {
                  _redirect(); // 리다이렉션 함수 호출
                  SecureTokenStorage.saveToken('test_token');
                  Navigator.pushNamed(context, '/home_main');
                },
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/kakao_icon.png', width: 24),
                text: '카카오로 시작하기',
                onTap: _redirect,
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/naver_icon.png', width: 24),
                text: '네이버로 시작하기',
                onTap: _redirect,
              ),
              const SizedBox(height: 16),
              _socialButton(
                icon: Image.asset('assets/images/login/apple_icon.png', width: 24),
                text: '애플로 시작하기    ',
                onTap: _redirect,
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
