import 'dart:async';
import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:daenglog_fe/shared/utils/location_service.dart';
import 'package:daenglog_fe/shared/services/kakao_location_service.dart';
import '../repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository;

  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  double? _latitude;
  double? _longitude;
  String? _regionText;

  WeatherProvider({WeatherRepository? weatherRepository})
      : _weatherRepository = weatherRepository ?? WeatherRepositoryImpl();

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get regionText => _regionText;

  Future<void> loadWeather() async {
    print('🔄 WeatherProvider.loadWeather() 시작');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1) 현재 위치(위도/경도) 한 번만 조회
      final locationService = LocationService();
      final position = await locationService.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;

      // 2) Kakao 로컬 API로 시도/구/동 조회
      try {
        final kakaoService = KakaoLocationService();
        final region = await kakaoService.getRegionFromLatLng(
          latitude: _latitude!,
          longitude: _longitude!,
        );
        _regionText = region.toString();
        print('📍 지역 조회 성공: $_regionText');
      } catch (e) {
        print('⚠️ Kakao 지역 조회 실패: $e');
        _regionText = null;
      }

      print('📡 WeatherRepository에서 날씨 데이터 요청 중...');
      final weather = await _weatherRepository.getCurrentWeather(
        latitude: _latitude,
        longitude: _longitude,
      );
      // Kakao에서 받은 주소가 있으면 Weather 모델의 location을 교체
      _weather = (_regionText != null)
          ? Weather(
              temperature: weather.temperature,
              humidity: weather.humidity,
              weather: weather.weather,
              location: _regionText!,
              airQuality: weather.airQuality,
              weatherType: weather.weatherType,
            )
          : weather;

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
