import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget buildOnboardingContent({
  required String titleHighlight, // 하이라이트 텍스트
  required String subtitle, // 서브타이틀 텍스트
  required String imagePath, // 이미지 파일 경로
  required BuildContext context, // 컨텍스트
  required String navigationButtonText, // 네비게이션 버튼 텍스트
  required int indicatorIndex, // 인디케이터 인덱스
}) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 9,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.grey, size: 20),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '댕댕일기 ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: titleHighlight, // 하이라이트 텍스트
                        style: const TextStyle(
                          color: Color(0xFFFF5F01),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  subtitle, // 서브타이틀 텍스트
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8C8B8B),
                    fontSize: 15,
                    fontFamily: 'Pretendard Medium',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                Image.asset(imagePath), // 이미지 파일 경로
                SizedBox(
                  width: 275,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5F01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, navigationButtonText); // 텍스트 + 네비게이션 버튼
                    },
                    child: const Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Pretendard Medium',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 12,
                      height: 12,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index == indicatorIndex // 인디케이터 인덱스
                            ? const Color(0xFFFF5F01)
                            : const Color(0xFFCDCDCD),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '이미 계정이 있으신가요? ',
                        style: TextStyle(
                          fontFamily: 'Pretendard Regular',
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      WidgetSpan(
                        child: _HoverableLoginText(context: context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// 로그인 텍스트 호버 효과
class _HoverableLoginText extends StatefulWidget {
  final BuildContext context;
  const _HoverableLoginText({required this.context});

  @override
  State<_HoverableLoginText> createState() => _HoverableLoginTextState();
}

// 로그인 텍스트 호버 효과
class _HoverableLoginTextState extends State<_HoverableLoginText> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(widget.context, '/login');
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'Pretendard Bold',
            color: const Color(0xFFFF5F01),
            fontSize: _hovering ? 18 : 16,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
          ),
          child: const Text('로그인'),
        ),
      ),
    );
  }
}
