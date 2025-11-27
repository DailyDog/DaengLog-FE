import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:daenglog_fe/shared/services/kakao_location_service.dart';

class LocationService {
  final KakaoLocationService _kakaoLocationService = KakaoLocationService();

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('위치 서비스가 꺼져 있습니다.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('위치 권한이 거부되었습니다.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('위치 권한이 영구적으로 거부되었습니다.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// 현재 기기의 위도/경도를 가져온 뒤,
  /// Kakao 로컬 API를 통해 시/도, 구/군, 동/읍/면 정보를 조회한다.
  Future<KakaoRegion> getCurrentRegion() async {
    final position = await getCurrentPosition();
    return _kakaoLocationService.getRegionFromLatLng(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Map<String, int> latLngToGrid(double lat, double lon) {
    const double RE = 6371.00877; // 지구 반경(km)
    const double GRID = 5.0;      // 격자 간격(km)
    const double SLAT1 = 30.0;    // 투영 위도1
    const double SLAT2 = 60.0;    // 투영 위도2
    const double OLON = 126.0;    // 기준 경도
    const double OLAT = 38.0;     // 기준 위도
    const double XO = 43;         // 기준 X좌표
    const double YO = 136;        // 기준 Y좌표

    double DEGRAD = pi / 180.0;

    double re = RE / GRID;
    double slat1 = SLAT1 * DEGRAD;
    double slat2 = SLAT2 * DEGRAD;
    double olon = OLON * DEGRAD;
    double olat = OLAT * DEGRAD;

    double sn = tan(pi * 0.25 + slat2 * 0.5) / tan(pi * 0.25 + slat1 * 0.5);
    sn = log(cos(slat1) / cos(slat2)) / log(sn);
    double sf = tan(pi * 0.25 + slat1 * 0.5);
    sf = pow(sf, sn) * cos(slat1) / sn;
    double ro = tan(pi * 0.25 + olat * 0.5);
    ro = re * sf / pow(ro, sn);

    double ra = tan(pi * 0.25 + lat * DEGRAD * 0.5);
    ra = re * sf / pow(ra, sn);
    double theta = lon * DEGRAD - olon;
    if (theta > pi) theta -= 2.0 * pi;
    if (theta < -pi) theta += 2.0 * pi;
    theta *= sn;

    int x = (ra * sin(theta) + XO + 0.5).floor();
    int y = (ro - ra * cos(theta) + YO + 0.5).floor();
    return {'nx': x, 'ny': y};
  }
}