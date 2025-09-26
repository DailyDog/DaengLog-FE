enum WeatherType { sunny, rainy, snowy }

class Weather {
  final String temperature; // 기온
  final String humidity; // 습도
  final String weather; // 날씨 상태 (맑음, 흐림 등)
  final String location; // 위치
  final String airQuality; // 미세먼지 상태
  final WeatherType weatherType; // 날씨 타입

  Weather({
    required this.temperature,
    required this.humidity,
    required this.weather,
    required this.location,
    required this.airQuality,
    required this.weatherType,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // 기상청 API 응답 구조에 맞게 파싱
    // 실제 API 응답 구조에 따라 수정 필요
    return Weather(
      temperature: json['temperature'],
      humidity: json['humidity'],
      weather: json['weather'],
      location: json['location'],
      airQuality: json['airQuality'],
      weatherType: _getWeatherType(json['weather']),
    );
  }

  // 기본 날씨 데이터 (API 연동 전 임시 사용)
  factory Weather.defaultWeather() {
    return Weather(
      temperature: '15',
      humidity: '60',
      weather: '맑음',
      location: '위치 정보 없음',
      airQuality: '좋음',
      weatherType: WeatherType.sunny,
    );
  }

  // 오전 날씨 정보 (임시로 현재 날씨와 동일하게 설정)
  Weather get morningWeather => Weather(
        temperature: temperature,
        humidity: humidity,
        weather: weather,
        location: location,
        airQuality: airQuality,
        weatherType: weatherType,
      );

  // 오후 날씨 정보 (임시로 현재 날씨와 동일하게 설정)
  Weather get afternoonWeather => Weather(
        temperature: temperature,
        humidity: humidity,
        weather: weather,
        location: location,
        airQuality: airQuality,
        weatherType: weatherType,
      );

  // 날씨 메시지
  String get weatherMessage {
    switch (weatherType) {
      case WeatherType.sunny:
        return '오늘 맑아요';
      case WeatherType.rainy:
        return '오늘 비가 와요';
      case WeatherType.snowy:
        return '오늘 눈이 와요';
    }
  }

  static WeatherType _getWeatherType(String weather) {
    if (weather.contains('맑음') || weather.contains('폭염')) {
      return WeatherType.sunny;
    } else if (weather.contains('비') ||
        weather.contains('소나기') ||
        weather.contains('폭우')) {
      return WeatherType.rainy;
    } else if (weather.contains('눈') || weather.contains('한파')) {
      return WeatherType.snowy;
    } else {
      return WeatherType.sunny; // 기본값
    }
  }
}
