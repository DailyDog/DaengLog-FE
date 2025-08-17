import 'package:flutter/material.dart';

class FreePlanWidget extends StatelessWidget {
  const FreePlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 화면 크기에 따른 동적 크기 계산
    final containerWidth = screenWidth * 0.85;
    final progressBarHeight = screenHeight * 0.035;
    final photoWidth = containerWidth * 0.43; // 2GB / 5GB = 0.4
    final videoWidth = containerWidth * 0.43; // 2.2GB / 5GB = 0.44
    
    return Container(
      width: containerWidth,
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '무료플랜',
            style: TextStyle(
              fontSize: screenWidth * 0.058,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5F01),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Text(
            '총 사용 용량',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Color(0xFF272727),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Container(
            width: double.infinity,
            height: progressBarHeight,
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Color(0xFF8C8B8B)),
            ),
            child: Stack(
              children: [
                // 사진 용량 (2GB)
                Positioned(
                  left: 0,
                  child: Container(
                    width: photoWidth,
                    height: progressBarHeight,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFA06A),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(7),
                        bottomLeft: Radius.circular(7),
                      ),
                    ),
                  ),
                ),
                // 동영상 용량 (2.2GB)
                Positioned(
                  left: photoWidth,
                  child: Container(
                    width: videoWidth,
                    height: progressBarHeight,
                    color: Color(0xFF95C6FF),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Row(
            children: [
              Container(
                width: screenWidth * 0.04,
                height: screenWidth * 0.04,
                decoration: BoxDecoration(
                  color: Color(0xFFFFA06A),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '사진 (2GB)',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF272727),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Container(
                width: screenWidth * 0.04,
                height: screenWidth * 0.04,
                decoration: BoxDecoration(
                  color: Color(0xFF95C6FF),
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '동영상 (2.2GB)',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF272727),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '4.2GB / 5GB',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF5F01),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
