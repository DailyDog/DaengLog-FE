import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/social_login/login_api.dart';

// 모달을 띄우는 함수
Future<void> showLoginModal(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LoginModal(),
  );
} 

class LoginModal extends StatelessWidget {
  const LoginModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // 메인 내용
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24), // x버튼 공간 확보
                // 로고
                Image.asset(
                  'assets/images/login/login_logo.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 16),
                // 설명
                const Text(
                  '로그인하고 모든 기능을 사용해 보세요.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8C8B8B),
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // 구글 로그인 버튼
                _socialButton(
                  icon: Image.asset('assets/images/login/google_icon.png', width: 20),
                  text: '구글로 시작하기',
                  onTap: () async {
                    await performGoogleLogin();
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // x 버튼 (오른쪽 상단)
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Color(0xfff2b2b2b)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
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
        width: 230,
        height: 35,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 14),
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w300,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
