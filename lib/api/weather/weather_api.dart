import 'package:geocoding/geocoding.dart'; // 위치 → 주소 변환용
import 'package:daenglog_fe/services/location_service.dart';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/models/homeScreen/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  final Dio _dio = Dio(); 
  final LocationService _locationService = LocationService();

  final String apiKey = dotenv.env['KMA_API_KEY']!;

  Future<Weather> getWeather() async {
    try {
      final position = await _locationService.getCurrentPosition();
      final grid = _locationService.latLngToGrid(position.latitude, position.longitude);

      // 주소(행정동명) 얻기
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: "ko_KR",
      );
      String locationName = '${placemarks.first.locality} ${placemarks.first.subLocality}';

      final now = DateTime.now();
      final baseDate = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final baseTime = '${now.hour.toString().padLeft(2, '0')}00';

      final response = await _dio.get(
        'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst',
        queryParameters: {
          'serviceKey': apiKey,
          'pageNo': '1',
          'numOfRows': '10',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          'nx': grid['nx'],
          'ny': grid['ny'],
        },
      );

      // 기상청 API 응답 파싱
      final items = response.data['response']['body']['items']['item'] as List;
      
      String temperature = '0';
      String humidity = '0';
      String weather = '맑음';
      
      for (var item in items) {
        final category = item['category'];
        final value = item['obsrValue'];
        
        switch (category) {
          case 'T1H': // 기온
            temperature = value.toString();
            break;
          case 'RN1': // 1시간 강수량
            final rainAmount = double.tryParse(value.toString()) ?? 0;
            if (rainAmount > 0) {
              weather = rainAmount > 10 ? '폭우' : '비';
            }
            break;
          case 'REH': // 습도
            humidity = value.toString();
            break;
          case 'PTY': // 강수형태
            final pty = int.tryParse(value.toString()) ?? 0;
            switch (pty) {
              case 0: // 없음
                weather = '맑음';
                break;
              case 1: // 비
                weather = '비';
                break;
              case 2: // 비/눈
                weather = '비/눈';
                break;
              case 3: // 눈
                weather = '눈';
                break;
              case 4: // 소나기
                weather = '소나기';
                break;
            }
            break;
        }
      }
      
      // 온도에 따른 날씨 상태 보정
      final temp = double.tryParse(temperature) ?? 0;
      if (temp >= 30) {
        weather = '폭염';
      } else if (temp <= -10) {
        weather = '한파';
      }
      
      final weatherJson = {
        'temperature': temperature,
        'humidity': humidity,
        'weather': weather,
        'airQuality': '좋음', // TODO: 미세먼지 API 연동 필요
        'location': locationName,
      };

      return Weather.fromJson(weatherJson);
    } catch (e) {
      print('날씨 API 실패: $e');
      return Weather.defaultWeather();
    }
  }
}