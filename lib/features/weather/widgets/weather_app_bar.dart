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

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
        ),
        child: Stack(
          children: [
            // 뒤로가기 버튼 (좌측)
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
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
            ),
            // 위치 정보 (가운데 정렬, 뒤로가기 버튼과 수직 정렬)
            Center(
              child: Text(
                location,
                style: TextStyle(
                  fontSize: baseFontSize * 1.3,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E2E2E),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
