import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import '../models/weather_extensions.dart';
import 'weather_card.dart';
import 'weather_illustration.dart';
import 'weather_action_button.dart';

class WeatherContent extends StatelessWidget {
  final Weather weather;

  const WeatherContent({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final todayWeatherType = weather.weatherType;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // 배경 원형 장식들
        _buildBackgroundDecorations(screenWidth),

        // 메인 콘텐츠
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20), // 상단 여백

              // 오전/오후 날씨 카드
              Row(
                children: [
                  Expanded(
                    child: WeatherCard(
                      title: '오전',
                      temperature: weather.morningWeather.temperatureDouble,
                      weatherType: weather.morningWeather.weatherType,
                      humidity: weather.morningWeather.humidityInt,
                      timeLabel: '어제보다',
                      description: weather.morningWeather.weather,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: WeatherCard(
                      title: '오후',
                      temperature: weather.afternoonWeather.temperatureDouble,
                      weatherType: weather.afternoonWeather.weatherType,
                      humidity: weather.afternoonWeather.humidityInt,
                      timeLabel: '어제보다',
                      description: weather.afternoonWeather.weather,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 날씨별 메시지
              Text(
                weather.weatherMessage,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: _getWeatherMessageColor(todayWeatherType),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // 날씨별 일러스트
              WeatherIllustration(
                weatherType: todayWeatherType,
                width: screenWidth - 48,
                height: 200,
              ),

              const SizedBox(height: 40),

              // 액션 버튼
              WeatherActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('산책 미션 기능을 준비 중입니다.'),
                      backgroundColor: Color(0xFFFF6B00),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // 하단 인디케이터
              Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecorations(double screenWidth) {
    return Stack(
      children: [
        // 좌상단 원
        Positioned(
          left: -54,
          top: 23,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.3),
            ),
          ),
        ),
        // 우상단 원
        Positioned(
          right: -28,
          top: 195,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.3),
            ),
          ),
        ),
        // 좌하단 원
        Positioned(
          left: -18,
          bottom: 200,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.3),
            ),
          ),
        ),
        // 우하단 원
        Positioned(
          right: -28,
          bottom: 50,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }

  Color _getWeatherMessageColor(WeatherType weatherType) {
    switch (weatherType) {
      case WeatherType.sunny:
        return const Color(0xFFFF5F01);
      case WeatherType.rainy:
        return const Color(0xFF567596);
      case WeatherType.snowy:
        return const Color(0xFF0167FF);
    }
  }
}
