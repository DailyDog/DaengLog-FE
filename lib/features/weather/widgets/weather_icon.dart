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
    return Icon(
      _getIconData(),
      size: size,
      color: color ?? _getDefaultColor(),
    );
  }

  IconData _getIconData() {
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
