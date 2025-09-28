import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:daenglog_fe/api/weather/weather_api.dart';

abstract class WeatherRepository {
  Future<Weather> getCurrentWeather();
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApi _weatherApi;

  WeatherRepositoryImpl({WeatherApi? weatherApi})
      : _weatherApi = weatherApi ?? WeatherApi();

  @override
  Future<Weather> getCurrentWeather() async {
    try {
      print('🏪 WeatherRepository.getCurrentWeather() 시작');
      final weather = await _weatherApi.getWeather();
      print('✅ WeatherRepository 성공: ${weather.weather}');
      return weather;
    } catch (e) {
      print('❌ WeatherRepository 오류: $e');
      print('🔄 기본 날씨 데이터 반환');
      return Weather.defaultWeather();
    }
  }
}
