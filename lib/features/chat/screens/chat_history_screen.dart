import 'package:flutter/material.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF5F01),
        title: Text(
          '히스토리', 
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Pretendard',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          // Date Badge
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 113,
                height: 27,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEDB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    '25.05.03(금)',
                    style: TextStyle(
                      color: Color(0xFFFF5F01),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Empty State Content
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Description Text
                  const Column(
                    children: [
                      Text(
                        '히스토리가 비어있네요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          color: Color(0xFF5C5C5C),
                          height: 1.54,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '일기를 생성해 보세요',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13,
                          color: Color(0xFF5C5C5C),
                          height: 1.54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
