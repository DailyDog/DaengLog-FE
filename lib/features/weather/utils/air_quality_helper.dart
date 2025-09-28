import 'package:flutter/material.dart';

class AirQualityHelper {
  static Color getAirQualityColor(String airQuality) {
    switch (airQuality) {
      case '좋음':
        return const Color(0xFF007AFF);
      case '보통':
        return const Color(0xFFFF9900);
      case '나쁨':
        return const Color(0xFFFF0000);
      case '매우나쁨':
        return const Color(0xFF8B0000);
      default:
        return const Color(0xFF007AFF);
    }
  }

  static String getAirQualityText(int humidity) {
    if (humidity < 30) {
      return '좋음';
    } else if (humidity < 60) {
      return '보통';
    } else {
      return '나쁨';
    }
  }
}
