import 'package:flutter/material.dart';

class WeatherLoading extends StatefulWidget {
  const WeatherLoading({super.key});

  @override
  State<WeatherLoading> createState() => _WeatherLoadingState();
}

class _WeatherLoadingState extends State<WeatherLoading> {
  bool _showDefault = false;

  @override
  void initState() {
    super.initState();
    // 1초 후 기본값 표시
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showDefault = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_showDefault) ...[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B00)),
            ),
            const SizedBox(height: 16),
            const Text(
              '날씨 정보를 불러오는 중...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ] else ...[
            const Icon(
              Icons.wb_sunny,
              size: 64,
              color: Color(0xFFFF6B00),
            ),
            const SizedBox(height: 16),
            const Text(
              '오늘 날씨는\n\'맑음\' 입니다',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '기본 날씨 정보를 표시합니다',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF8C8B8B),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
