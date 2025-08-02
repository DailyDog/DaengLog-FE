import 'package:geocoding/geocoding.dart'; // 위치 → 주소 변환용
import 'package:daenglog_fe/shared/utils/location_service.dart';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  final Dio _dio = Dio(); 
  final LocationService _locationService = LocationService();

  final String weatherApiKey = dotenv.env['KMA_API_KEY']!;
  
  Future<Weather> getWeather() async {
    print(weatherApiKey);
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

      final now = DateTime.now().toLocal();
      final baseDate = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      
      // 기상청 API는 매시각 40분 이후에 해당 시각 자료를 제공
      // 예: 02:40 이후에 02:00 자료 제공
      int hour = now.hour;
      if (now.minute < 40) {
        hour = hour - 1;
        if (hour < 0) hour = 23;
      }
      final baseTime = '${hour.toString().padLeft(2, '0')}00';

      final response = await _dio.get(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst',
        queryParameters: {
          'serviceKey': weatherApiKey,
          'numOfRows': '10',
          'pageNo': '1',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          // 'nx': grid['nx'].toString(),
          // 'ny': grid['ny'].toString(),
          'nx': '55',
          'ny': '127',
        },
      );

      print(response.data);
      
      // 기상청 API 응답 파싱
      final itemsData = response.data['response']['body']['items']['item'];
      List items;
      
      // items가 단일 객체인지 배열인지 확인
      if (itemsData is List) {
        items = itemsData;
      } else {
        items = [itemsData]; // 단일 객체를 배열로 변환
      }
      
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