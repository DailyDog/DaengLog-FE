import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange, // 주황색 배경
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '댕댕일기', // 제목
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 텍스트 색상
                ),
              ),
              SizedBox(height: 20), // 간격
              Text(
                '반려동물과의 커뮤니케이션', // 부제목
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // 텍스트 색상
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
