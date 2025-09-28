import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import 'weather_icon.dart';
import '../utils/air_quality_helper.dart';

class WeatherInfoCard extends StatelessWidget {
  final String title;
  final Weather weather;
  final double screenWidth;

  const WeatherInfoCard({
    super.key,
    required this.title,
    required this.weather,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = screenWidth * 0.045;
    final temperatureFontSize = screenWidth * 0.08;
    final rainFontSize = screenWidth * 0.035;

    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: baseFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E2E2E),
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 20),
          // 날씨 아이콘 (크기 증가)
          WeatherIcon(
            weatherType: weather.weatherType,
            size: 60,
          ),
          const SizedBox(height: 10),
          Text(
            '${weather.temperature} ℃',
            style: TextStyle(
              fontSize: temperatureFontSize * 0.7, // 온도 글씨 크기 감소
              fontWeight: FontWeight.w400,
              color: const Color(0xFF2E2E2E),
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '강수확률',
                style: TextStyle(
                  fontSize: rainFontSize,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2E2E2E),
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getRainProbability(weather.weatherType),
                style: TextStyle(
                  fontSize: rainFontSize,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF2E2E2E),
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 미세먼지 정보 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '미세먼지 | ',
                style: TextStyle(
                  fontSize: rainFontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8C8B8B),
                  fontFamily: 'Pretendard',
                ),
              ),
              Text(
                weather.airQuality,
                style: TextStyle(
                  fontSize: rainFontSize,
                  fontWeight: FontWeight.w500,
                  color:
                      AirQualityHelper.getAirQualityColor(weather.airQuality),
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getRainProbability(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return '10%';
      case WeatherType.rainy:
        return '80%';
      case WeatherType.snowy:
        return '60%';
    }
  }
}
