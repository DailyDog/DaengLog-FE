import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';

class WeatherIcon extends StatelessWidget {
  final WeatherType weatherType;
  final double size;
  final Color? color;

  const WeatherIcon({
    super.key,
    required this.weatherType,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _getIconPath(),
      width: size,
      height: size,
      errorBuilder: (context, error, stackTrace) {
        // 이미지 로드 실패 시 기본 아이콘 사용
        return Icon(
          _getFallbackIcon(),
          size: size,
          color: color ?? _getDefaultColor(),
        );
      },
    );
  }

  String _getIconPath() {
    switch (weatherType) {
      case WeatherType.sunny:
        return 'assets/images/weather/sunny_icon.png';
      case WeatherType.rainy:
        return 'assets/images/weather/rainy_icon.png';
      case WeatherType.snowy:
        return 'assets/images/weather/snowy_icon.png';
    }
  }

  IconData _getFallbackIcon() {
    switch (weatherType) {
      case WeatherType.sunny:
        return Icons.wb_sunny;
      case WeatherType.rainy:
        return Icons.grain;
      case WeatherType.snowy:
        return Icons.ac_unit;
    }
  }

  Color _getDefaultColor() {
    switch (weatherType) {
      case WeatherType.sunny:
        return const Color(0xFFFFB800);
      case WeatherType.rainy:
        return const Color(0xFF007AFF);
      case WeatherType.snowy:
        return const Color(0xFF87CEEB);
    }
  }
}
