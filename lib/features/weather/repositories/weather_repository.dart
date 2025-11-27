import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:daenglog_fe/api/weather/weather_api.dart';

abstract class WeatherRepository {
  /// 현재 위치 기준 날씨 조회
  /// - latitude, longitude가 주어지면 해당 좌표를 사용
  /// - 없으면 내부에서 현재 위치를 다시 조회
  Future<Weather> getCurrentWeather({
    double? latitude,
    double? longitude,
  });
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApi _weatherApi;

  WeatherRepositoryImpl({WeatherApi? weatherApi})
      : _weatherApi = weatherApi ?? WeatherApi();

  @override
  Future<Weather> getCurrentWeather({
    double? latitude,
    double? longitude,
  }) async {
    try {
      print('🏪 WeatherRepository.getCurrentWeather() 시작');
      final weather = (latitude != null && longitude != null)
          ? await _weatherApi.getWeatherByLatLng(
              latitude: latitude,
              longitude: longitude,
            )
          : await _weatherApi.getWeather();
      print('✅ WeatherRepository 성공: ${weather.weather}');
      return weather;
    } catch (e) {
      print('❌ WeatherRepository 오류: $e');
      print('🔄 기본 날씨 데이터 반환');
      return Weather.defaultWeather();
    }
  }
}
