import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final double temperature;
  final WeatherType weatherType;
  final int humidity;
  final String timeLabel;
  final String description;

  const WeatherCard({
    super.key,
    required this.title,
    required this.temperature,
    required this.weatherType,
    required this.humidity,
    required this.timeLabel,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E2E2E),
            ),
          ),

          const SizedBox(height: 20),

          // 날씨 아이콘
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: _getWeatherIcon(),
            ),
          ),

          const SizedBox(height: 20),

          // 온도
          Center(
            child: Text(
              '${temperature.toStringAsFixed(1)}°C',
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 강수확률
          Center(
            child: Text(
              '강수확률 $humidity%',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 미세먼지 정보
          Center(
            child: Text(
              '미세먼지 | ${_getAirQualityText()}',
              style: TextStyle(
                fontSize: 11,
                color: const Color(0xFF8C8B8B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWeatherIcon() {
    switch (weatherType) {
      case WeatherType.sunny:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFFE4B3),
          ),
          child: const Icon(
            Icons.wb_sunny,
            size: 60,
            color: Color(0xFFFF6B00),
          ),
        );
      case WeatherType.rainy:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFB3D9FF),
          ),
          child: const Icon(
            Icons.cloud_queue,
            size: 60,
            color: Color(0xFF567596),
          ),
        );
      case WeatherType.snowy:
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFE6F3FF),
          ),
          child: const Icon(
            Icons.ac_unit,
            size: 60,
            color: Color(0xFF0167FF),
          ),
        );
    }
  }

  String _getAirQualityText() {
    // 간단한 미세먼지 상태 시뮬레이션
    if (humidity < 30) {
      return '좋음';
    } else if (humidity < 60) {
      return '보통';
    } else {
      return '나쁨';
    }
  }
}
