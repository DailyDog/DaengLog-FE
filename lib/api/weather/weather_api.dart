import 'package:geocoding/geocoding.dart'; // 위치 → 주소 변환용
import 'package:daenglog_fe/shared/utils/location_service.dart';
import 'package:dio/dio.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherApi {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ));
  final LocationService _locationService = LocationService();

  final String weatherApiKey = dotenv.env['KMA_API_KEY'] ?? '';

  Future<Weather> getWeather() async {
    print('🌤️ WeatherApi.getWeather() 시작');
    print(
        '🔑 API Key: ${weatherApiKey.isEmpty ? "없음 (공개 API 사용)" : weatherApiKey.substring(0, 8) + "..."}');

    try {
      print('📍 위치 정보 가져오는 중...');
      final position = await _locationService.getCurrentPosition();
      print('📍 위치: ${position.latitude}, ${position.longitude}');

      final grid =
          _locationService.latLngToGrid(position.latitude, position.longitude);
      print('🗺️ 그리드 좌표: ${grid}');

      // 주소(행정동명) 얻기
      print('🏠 주소 정보 가져오는 중...');
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: "ko_KR",
      );
      String locationName =
          '${placemarks.first.locality} ${placemarks.first.subLocality}';
      print('🏠 주소: $locationName');

      final now = DateTime.now().toLocal();

      // 기상청 API는 매시각 40분 이후에 해당 시각 자료를 제공
      // 예: 02:40 이후에 02:00 자료 제공
      int hour = now.hour;
      DateTime baseDateTime = now;

      if (now.minute < 40) {
        hour = hour - 1;
        if (hour < 0) {
          hour = 23;
          // 날짜도 하루 빼기
          baseDateTime = now.subtract(const Duration(days: 1));
        }
      }

      final baseDate =
          '${baseDateTime.year}${baseDateTime.month.toString().padLeft(2, '0')}${baseDateTime.day.toString().padLeft(2, '0')}';
      final baseTime = '${hour.toString().padLeft(2, '0')}00';

      // 디버깅: 현재 시간과 계산된 시간 출력
      print('🕐 현재 시간: ${now.hour}:${now.minute}');
      print('🕐 계산된 시간: $baseTime');

      print('📅 날짜/시간: $baseDate $baseTime');
      print('🌐 API 호출 시작...');

      // 기상청 API는 API 키가 필수이므로, 키가 없으면 기본 데이터 반환
      if (weatherApiKey.isEmpty) {
        print('⚠️ API 키가 없어서 기본 날씨 데이터를 반환합니다');

        // 시간대와 계절에 따른 기본 날씨 생성
        final hour = now.hour;
        final month = now.month;

        String weather = '맑음';
        String temperature = '22';
        String humidity = '65';
        WeatherType weatherType = WeatherType.sunny;

        // 계절별 기본 온도
        if (month >= 3 && month <= 5) {
          // 봄
          temperature = '18';
        } else if (month >= 6 && month <= 8) {
          // 여름
          temperature = '28';
        } else if (month >= 9 && month <= 11) {
          // 가을
          temperature = '20';
        } else {
          // 겨울
          temperature = '5';
        }

        // 시간대별 온도 조정
        if (hour >= 6 && hour <= 10) {
          // 아침
          temperature = (int.parse(temperature) - 3).toString();
        } else if (hour >= 14 && hour <= 18) {
          // 오후
          temperature = (int.parse(temperature) + 5).toString();
        } else if (hour >= 19 || hour <= 5) {
          // 저녁/밤
          temperature = (int.parse(temperature) - 2).toString();
        }

        // 간단한 날씨 변화 (시간 기반)
        if (hour % 4 == 0) {
          weather = '흐림';
          weatherType = WeatherType.rainy;
        } else if (hour % 7 == 0) {
          weather = '비';
          weatherType = WeatherType.rainy;
        }

        return Weather(
          temperature: temperature,
          humidity: humidity,
          weather: weather,
          location: locationName,
          airQuality: '좋음',
          weatherType: weatherType,
        );
      }

      final response = await _dio.get(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst',
        queryParameters: {
          'serviceKey': weatherApiKey,
          'numOfRows': '10',
          'pageNo': '1',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          'nx': grid['nx'].toString(),
          'ny': grid['ny'].toString(),
        },
      );

      print('✅ API 응답 성공!');
      print('📊 응답 상태코드: ${response.statusCode}');
      print('📊 응답 데이터 타입: ${response.data.runtimeType}');

      // 응답 데이터가 null이거나 빈 경우 체크
      if (response.data == null) {
        print('❌ 응답 데이터가 null입니다');
        throw Exception('API 응답 데이터가 null입니다');
      }

      print('📊 응답 데이터: ${response.data}');

      // 기상청 API 응답 파싱
      print('🔍 응답 데이터 파싱 시작...');

      // 응답 구조 확인
      if (response.data['response'] == null) {
        print('❌ response 필드가 없습니다');
        throw Exception('API 응답에 response 필드가 없습니다');
      }

      if (response.data['response']['body'] == null) {
        print('❌ body 필드가 없습니다');
        throw Exception('API 응답에 body 필드가 없습니다');
      }

      if (response.data['response']['body']['items'] == null) {
        print('❌ items 필드가 없습니다');
        throw Exception('API 응답에 items 필드가 없습니다');
      }

      final itemsData = response.data['response']['body']['items']['item'];
      print('📋 items 데이터: $itemsData');

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
      print('❌ 날씨 API 실패: $e');
      print('📋 에러 타입: ${e.runtimeType}');
      print('🔍 스택 트레이스: ${StackTrace.current}');

      // API 실패 시 기본 날씨 데이터 반환
      print('🔄 기본 날씨 데이터 반환');
      return Weather(
        temperature: '25',
        humidity: '65',
        weather: '맑음',
        location: '정릉동',
        airQuality: '좋음',
        weatherType: WeatherType.sunny,
      );
    }
  }
}
