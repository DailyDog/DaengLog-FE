import 'package:flutter/material.dart';

class WeatherAppBar extends StatelessWidget {
  final String location;
  final VoidCallback onBackPressed;
  final double screenWidth;

  const WeatherAppBar({
    super.key,
    required this.location,
    required this.onBackPressed,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = screenWidth * 0.045;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // 뒤로가기 버튼
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),

          // 위치 정보 (가운데 정렬)
          Expanded(
            child: Center(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: baseFontSize * 1.2,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E2E2E),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ),

          // 오른쪽 공간 (뒤로가기 버튼과 균형 맞추기)
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
