import 'package:daenglog_fe/shared/models/weather.dart';

extension WeatherExtensions on Weather {
  double get temperatureDouble => double.tryParse(temperature) ?? 0.0;

  int get humidityInt => int.tryParse(humidity) ?? 0;

  // 오전/오후 데이터 시뮬레이션 (기상청 API는 현재 데이터만 제공)
  Weather get morningWeather => Weather(
        temperature: temperature,
        humidity: humidity,
        weather: weather,
        location: location,
        airQuality: airQuality,
        weatherType: weatherType,
      );

  Weather get afternoonWeather => Weather(
        temperature:
            (temperatureDouble + 2).toStringAsFixed(1), // 오후가 2도 높다고 가정
        humidity: (humidityInt - 5).toString(), // 오후가 5% 낮다고 가정
        weather: weather,
        location: location,
        airQuality: airQuality,
        weatherType: weatherType,
      );
}
