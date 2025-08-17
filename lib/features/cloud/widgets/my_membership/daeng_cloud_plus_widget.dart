import 'package:flutter/material.dart';

class DaengCloudPlusWidget extends StatelessWidget {
  const DaengCloudPlusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 화면 크기에 따른 동적 크기 계산
    final containerWidth = screenWidth * 0.85;
    final buttonHeight = screenHeight * 0.055;
    
    return Container(
      width: containerWidth,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Color(0xFFFFEEDB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFFFE8CD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '댕클라우드 +',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Color(0xFF272727),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: screenWidth * 0.05,
                color: Color(0xFFFF5F01),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  '월 1,900원의 저렴한 가격 (100GB 상품 기준)',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF272727),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: screenWidth * 0.05,
                color: Color(0xFFFF5F01),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  '45GB부터 1TB까지 다양한 용량 옵션',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF272727),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: screenWidth * 0.05,
                color: Color(0xFFFF5F01),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  '부분 유료 서비스 무료 이용',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF272727),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: screenWidth * 0.05,
                color: Color(0xFFFF5F01),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Text(
                  '다양한 가족 요금제 혜택',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF272727),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.025),
          Container(
            width: double.infinity,
            height: buttonHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF5F01), Color(0xFFFF7F34)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '댕클라우드 + 시작하기',
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
