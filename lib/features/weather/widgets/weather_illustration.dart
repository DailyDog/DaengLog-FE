import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';

class WeatherIllustration extends StatelessWidget {
  final WeatherType weatherType;
  final double width;
  final double height;

  const WeatherIllustration({
    super.key,
    required this.weatherType,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _getBackgroundColor(weatherType),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 배경 그라데이션
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: _getBackgroundGradient(weatherType),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // 메인 일러스트
            Center(
              child: _getMainIllustration(),
            ),
            // 날씨별 추가 요소들
            ..._getWeatherElements(),
          ],
        ),
      ),
    );
  }

  Widget _getMainIllustration() {
    switch (weatherType) {
      case WeatherType.sunny:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wb_sunny,
              size: 80,
              color: Color(0xFFFF6B00),
            ),
            const SizedBox(height: 16),
            Text(
              '망고가 산책 나갈 기분인지 알아볼까요?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8C8B8B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case WeatherType.rainy:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_queue,
              size: 80,
              color: Color(0xFF567596),
            ),
            const SizedBox(height: 16),
            Text(
              '비 오는 날 망고와 함께할 수 있는 놀이는?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8C8B8B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
      case WeatherType.snowy:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.ac_unit,
              size: 80,
              color: Color(0xFF0167FF),
            ),
            const SizedBox(height: 16),
            Text(
              '강아지는 눈을 좋아하는 동물로 알려져 있어요',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8C8B8B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        );
    }
  }

  List<Widget> _getWeatherElements() {
    switch (weatherType) {
      case WeatherType.sunny:
        return [
          // 해 아이콘들
          Positioned(
            left: width * 0.2,
            top: height * 0.2,
            child: const Icon(
              Icons.wb_sunny,
              size: 30,
              color: Color(0xFFFF6B00),
            ),
          ),
          Positioned(
            right: width * 0.2,
            top: height * 0.2,
            child: const Icon(
              Icons.wb_sunny,
              size: 30,
              color: Color(0xFFFF6B00),
            ),
          ),
        ];
      case WeatherType.rainy:
        return [
          // 비 구름들
          Positioned(
            left: width * 0.15,
            top: height * 0.15,
            child: const Icon(
              Icons.cloud_queue,
              size: 40,
              color: Color(0xFF567596),
            ),
          ),
          Positioned(
            right: width * 0.15,
            top: height * 0.15,
            child: const Icon(
              Icons.cloud_queue,
              size: 40,
              color: Color(0xFF567596),
            ),
          ),
        ];
      case WeatherType.snowy:
        return [
          // 눈송이들
          Positioned(
            left: width * 0.2,
            top: height * 0.1,
            child: const Icon(
              Icons.ac_unit,
              size: 25,
              color: Color(0xFF0167FF),
            ),
          ),
          Positioned(
            right: width * 0.2,
            top: height * 0.1,
            child: const Icon(
              Icons.ac_unit,
              size: 25,
              color: Color(0xFF0167FF),
            ),
          ),
          Positioned(
            left: width * 0.1,
            bottom: height * 0.2,
            child: const Icon(
              Icons.ac_unit,
              size: 20,
              color: Color(0xFF0167FF),
            ),
          ),
          Positioned(
            right: width * 0.1,
            bottom: height * 0.2,
            child: const Icon(
              Icons.ac_unit,
              size: 20,
              color: Color(0xFF0167FF),
            ),
          ),
        ];
    }
  }

  Color _getBackgroundColor(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return const Color(0xFFFFE4B3);
      case WeatherType.rainy:
        return const Color(0xFFB3D9FF);
      case WeatherType.snowy:
        return const Color(0xFFE6F3FF);
    }
  }

  Gradient _getBackgroundGradient(WeatherType type) {
    switch (type) {
      case WeatherType.sunny:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE4B3),
            Color(0xFFFFF4E6),
          ],
        );
      case WeatherType.rainy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB3D9FF),
            Color(0xFFE6F3FF),
          ],
        );
      case WeatherType.snowy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6F3FF),
            Color(0xFFF0F8FF),
          ],
        );
    }
  }
}
