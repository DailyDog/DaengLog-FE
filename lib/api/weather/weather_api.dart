import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:daenglog_fe/shared/utils/location_service.dart';
import 'package:daenglog_fe/shared/models/weather.dart';

class WeatherApi {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      // 기상청 API가 느릴 수 있어서 수신 타임아웃을 여유 있게 늘림
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 10),
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  final LocationService _locationService = LocationService();
  final String weatherApiKey = dotenv.env['KMA_API_KEY'] ?? '';

  // 위치 캐시
  String? _cachedLocation;
  DateTime? _lastLocationUpdate;

  /// 홈 화면 등에서 사용하는 기본 진입 메서드
  /// - 내부적으로 위치 정보를 가져와서, 현재 좌표 기반 PTY(강수 형태)만으로 날씨를 계산한다.
  /// - 추후 전체 예보 API로 확장하고 싶으면 이 메서드만 수정하면 됨.
  Future<Weather> getWeather() async {
    return getWeatherByPtyOnly();
  }

  /// 외부에서 이미 위도/경도를 얻어놓은 경우 사용하는 버전
  /// - 같은 위도/경도를 기상청 API(nx, ny 계산)와 다른 서비스(Kakao 등)에 함께 쓰고 싶을 때 사용
  Future<Weather> getWeatherByLatLng({
    required double latitude,
    required double longitude,
  }) async {
    print('🌤️ getWeatherByLatLng() 시작: ($latitude, $longitude)');

    final now = DateTime.now();
    final baseDate = _formatDate(now);
    final baseTime = _formatTime(now);

    // 위/경도 → 격자좌표(nx, ny)
    final grid = _locationService.latLngToGrid(latitude, longitude);

    // 위치 이름 (위/경도 기반)
    final locationName =
        await _getLocationNameFromLatLng(latitude: latitude, longitude: longitude);

    if (weatherApiKey.isEmpty) {
      print('⚠️ API 키 없음 → 기본 값 반환');
      return _createDefaultWeather(locationName, now);
    }

    try {
      final response = await _dio.get(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst',
        queryParameters: {
          'serviceKey': weatherApiKey,
          'numOfRows': '1000',
          'pageNo': '1',
          'dataType': 'JSON',
          'base_date': baseDate,
          'base_time': baseTime,
          'nx': grid['nx'].toString(),
          'ny': grid['ny'].toString(),
        },
      );

      print('✅ API 응답 코드: ${response.statusCode}');

      if (response.data == null) {
        throw Exception('응답 데이터가 null입니다.');
      }

      final data = response.data as Map<String, dynamic>;
      final itemsData = data['response']['body']['items']['item'];
      final List<dynamic> items =
          itemsData is List ? itemsData : [itemsData];

      final ptyItem = items.firstWhere(
        (item) => item['category'] == 'PTY',
        orElse: () => null,
      );

      int pty = 0;
      if (ptyItem != null) {
        pty = int.tryParse(ptyItem['obsrValue'].toString()) ?? 0;
      }

      final weatherText = _ptyToWeatherText(pty);
      final weatherType = _ptyToWeatherType(pty);

      return Weather(
        temperature: '22',
        humidity: '65',
        weather: weatherText,
        location: locationName,
        airQuality: '좋음', // 여기 수정해야됨
        weatherType: weatherType,
      );
    } catch (e, s) {
      print('❌ getWeatherByLatLng 실패: $e');
      print(s);
      return _createDefaultWeather(locationName, now);
    }
  }

  /// ✅ PTY만 사용해서 날씨를 구하는 간단 버전
  Future<Weather> getWeatherByPtyOnly() async {
    print('🌤️ getWeatherByPtyOnly() 시작');

    final now = DateTime.now();
    final baseDate = _formatDate(now);
    final baseTime = _formatTime(now);

    // 위치 이름 가져오기
    final locationName = await _getLocationName();

    // 위/경도 → 격자좌표(nx, ny)
    final grid = await _getGridCoordinates();
    if (grid == null) {
      print('⚠️ 그리드 좌표를 가져올 수 없어 기본 값 반환');
      return _createDefaultWeather(locationName, now);
    }

    // API 키 없으면 기본 값
    if (weatherApiKey.isEmpty) {
      print('⚠️ API 키 없음 → 기본 값 반환');
      return _createDefaultWeather(locationName, now);
    }

    try {
      final response = await _dio.get(
        'https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst',
        queryParameters: {
          'serviceKey': weatherApiKey,
          'numOfRows': '1000',
          'pageNo': '1',
          'dataType': 'JSON',
          'base_date': baseDate, // 예: 20251116
          'base_time': baseTime, // 예: 0600
          'nx': grid['nx'].toString(),
          'ny': grid['ny'].toString(),
        },
      );

      print('✅ API 응답 코드: ${response.statusCode}');
      print('📊 응답 타입: ${response.data.runtimeType}');

      if (response.data == null) {
        throw Exception('응답 데이터가 null입니다.');
      }

      final data = response.data as Map<String, dynamic>;

      // 응답 구조 방어 코드: body나 items가 없으면 기본 값 반환
      final responseRoot = data['response'] as Map<String, dynamic>?;
      final responseBody = responseRoot?['body'] as Map<String, dynamic>?;
      final items = responseBody?['items']?['item'];

      if (items == null) {
        print('⚠️ 기상청 응답에 items가 없습니다. data: $data');
        return _createDefaultWeather(locationName, now);
      }

      // item이 List인지, 단일 Map인지 구분
      final List<dynamic> itemList =
          items is List ? items : [items];

      // 🔎 PTY 카테고리만 찾기 (Python 코드와 동일한 로직)
      final ptyItem = itemList.firstWhere(
        (item) => item['category'] == 'PTY',
        orElse: () => null,
      );

      int pty = 0;
      if (ptyItem != null) {
        pty = int.tryParse(ptyItem['obsrValue'].toString()) ?? 0;
      }

      print('🌧️ PTY 값: $pty');

      // PTY → 날씨 텍스트/타입 매핑
      final weatherText = _ptyToWeatherText(pty);
      final weatherType = _ptyToWeatherType(pty);

      // 온도/습도는 PTY 버전에서는 모름 → placeholder 값 사용
      final weather = Weather(
        temperature: '22',
        humidity: '65',
        weather: weatherText,
        location: locationName,
        airQuality: '좋음',
        weatherType: weatherType,
      );

      print('🌧️ 최종 Weather: ${weather.weather}, ${weather.weatherType}');
      return weather;
    } catch (e, s) {
      print('❌ PTY 기반 날씨 조회 실패: $e');
      print(s);
      return _createDefaultWeather(locationName, now);
    }
  }

  /// PTY 코드 → 날씨 텍스트 매핑
  String _ptyToWeatherText(int pty) {
    switch (pty) {
      case 0:
        return '맑음';
      case 1:
        return '비';
      case 2:
        return '비/눈';
      case 3:
        return '눈';
      case 4:
        return '소나기';
      default:
        return '알 수 없음';
    }
  }

  /// PTY 코드 → WeatherType 매핑
  WeatherType _ptyToWeatherType(int pty) {
    switch (pty) {
      case 1:
      case 2:
      case 4:
        return WeatherType.rainy;
      case 3:
        return WeatherType.snowy;
      case 0:
      default:
        return WeatherType.sunny;
    }
  }

  /// 날짜 포맷: YYYYMMDD
  String _formatDate(DateTime dt) {
    return dt.year.toString().padLeft(4, '0') +
        dt.month.toString().padLeft(2, '0') +
        dt.day.toString().padLeft(2, '0');
  }

  /// 시간 포맷: HH00 (예: 06시 → 0600)
  String _formatTime(DateTime dt) {
    return dt.hour.toString().padLeft(2, '0') + '00';
  }

  // ================== 아래는 네가 기존 코드에서 이미 갖고 있던 유틸 ==================

  Future<String> _getLocationName() async {
    if (_cachedLocation != null &&
        _lastLocationUpdate != null &&
        DateTime.now().difference(_lastLocationUpdate!).inMinutes < 5) {
      print('📍 캐시된 위치 사용: $_cachedLocation');
      return _cachedLocation!;
    }

    try {
      final position = await _locationService.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: 'ko_KR',
      );
      final name =
          '${placemarks.first.locality} ${placemarks.first.subLocality}';
      _cachedLocation = name;
      _lastLocationUpdate = DateTime.now();
      return name;
    } catch (e) {
      print('❌ 위치 정보 실패: $e');
      return _cachedLocation ?? '위치 정보 없음';
    }
  }

  /// 위/경도를 직접 받아서 위치 이름을 구하는 버전
  Future<String> _getLocationNameFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
        localeIdentifier: 'ko_KR',
      );
      return '${placemarks.first.locality} ${placemarks.first.subLocality}';
    } catch (e) {
      print('❌ 위치 정보 실패(lat/lng): $e');
      return '위치 정보 없음';
    }
  }

  Future<Map<String, int>?> _getGridCoordinates() async {
    try {
      final position = await _locationService.getCurrentPosition();
      return _locationService.latLngToGrid(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      print('❌ 그리드 좌표 실패: $e');
      return null;
    }
  }

  Weather _createDefaultWeather(String locationName, DateTime now) {
    // 네가 원래 쓰던 기본값 로직 그대로 써도 됨
    return Weather(
      temperature: '22',
      humidity: '65',
      weather: '맑음',
      location: locationName,
      airQuality: '좋음',
      weatherType: WeatherType.sunny,
    );
  }
}