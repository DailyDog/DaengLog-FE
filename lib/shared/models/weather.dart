class Weather {
  final String temperature; // 기온
  final String humidity;    // 습도
  final String weather;     // 날씨 상태 (맑음, 흐림 등)
  final String location;    // 위치
  final String airQuality;  // 미세먼지 상태

  Weather({
    required this.temperature,
    required this.humidity,
    required this.weather,
    required this.location,
    required this.airQuality,
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
  );
}
} 