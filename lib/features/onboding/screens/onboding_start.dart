import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnbodingStart extends StatelessWidget {
  const OnbodingStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/onboding/onboding.png', width: 300, height: 100),
              const SizedBox(height: 48),

              // 대표로고
              Image.asset('assets/images/home/daeng.png', width: 100, height: 100),
              const SizedBox(height: 80),
              SizedBox(
                width: 300,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),

                  // 시작 버트 클릭 시 라우트 이동
                  onPressed: () {
                    Navigator.pushNamed(context, '/home_prompt'); 
                  },
                  child: const Text(
                    '시작하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '이미 계정이 있으신가요?',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              GestureDetector(
                // 로그인 버튼 클릭 시 라우트 이동
                onTap: () {
                  context.go('/login');
                },
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    color: Color(0xFFFF4B00),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFFF4B00),
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
