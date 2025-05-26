import 'package:flutter/material.dart';

class OnbodingStart extends StatelessWidget {
  const OnbodingStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                '댕댕일기',
                style: TextStyle(
                  color: Color(0xFFFF4B00),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '반려동물과의 커뮤니케이션',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '대표로고',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: 350,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4B00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),

                  // 시작 버트 클릭 시 라우트 이동
                  onPressed: () {
                    Navigator.pushNamed(context, '/onboding_first'); 
                  },
                  child: const Text(
                    '시작',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  '로그인',
                  style: TextStyle(
                    color: Color(0xFFFF4B00),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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
