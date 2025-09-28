import 'dart:async';
import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import '../repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  WeatherProvider({WeatherRepository? weatherRepository})
      : _weatherRepository = weatherRepository ?? WeatherRepositoryImpl();

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadWeather() async {
    print('🔄 WeatherProvider.loadWeather() 시작');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('📡 WeatherRepository에서 날씨 데이터 요청 중...');
      _weather = await _weatherRepository.getCurrentWeather().timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          print('⏰ Weather API timeout, using default weather');
          throw TimeoutException(
              'Weather API timeout', const Duration(seconds: 1));
        },
      );
      print('✅ 날씨 데이터 로드 성공: ${_weather?.weather}');
    } catch (e) {
      print('❌ WeatherProvider 에러: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      print('🏁 WeatherProvider 로딩 완료');
      notifyListeners();
    }
  }

  String getWeatherIconPath(weatherType) {
    switch (weatherType.toString()) {
      case 'WeatherType.sunny':
        return 'assets/images/weather/sunny_icon.png';
      case 'WeatherType.rainy':
        return 'assets/images/weather/rainy_icon.png';
      case 'WeatherType.snowy':
        return 'assets/images/weather/snowy_icon.png';
      default:
        return 'assets/images/weather/sunny_icon.png';
    }
  }
}
