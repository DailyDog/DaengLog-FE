import 'package:flutter/material.dart';

class StorageManagementButtonsWidget extends StatelessWidget {
  const StorageManagementButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 화면 크기에 따른 동적 크기 계산
    final containerWidth = screenWidth * 0.85;
    final buttonHeight = screenHeight * 0.038;
    final dividerHeight = screenHeight * 0.018;
    
    return Container(
      width: containerWidth,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      height: buttonHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF8C8B8B)),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                '용량 관리',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF272727),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: dividerHeight,
            color: Color(0xFF8C8B8B),
          ),
          Expanded(
            child: Center(
              child: Text(
                '요금제 변경',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF272727),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: dividerHeight,
            color: Color(0xFF8C8B8B),
          ),
          Expanded(
            child: Center(
              child: Text(
                '파일 정리',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF272727),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
