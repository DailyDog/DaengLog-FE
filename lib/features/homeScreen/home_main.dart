// 바텀 네비게이션 위젯
import 'package:daenglog_fe/common/widgets/bottom/home_bottom_nav_bar.dart';
// 홈 메인 위젯 패키지
import 'package:daenglog_fe/common/widgets/home_main.widgets/bottom_section_widget.dart'; // 홈 화면 망고의 일주일 밑 부분 위젯
import 'package:daenglog_fe/common/widgets/home_main.widgets/middle_section_widget.dart'; // 홈 화면 망고의 일주일 영역
import 'package:daenglog_fe/common/widgets/home_main.widgets/top_section_widget.dart'; // 홈 화면 망고의 일주일까지 위젯

// 플러터 위젯 패키지
import 'package:flutter/material.dart';

// dio 패키지
// retrofit 패키지
// json 패키지
// 홈 스크린 패키지
import 'package:daenglog_fe/api/homeScreen/album_detail_api.dart';
import 'package:daenglog_fe/api/homeScreen/category_api.dart';
import 'package:daenglog_fe/api/weather/weather_api.dart';
// 모델 패키지
import 'package:daenglog_fe/models/homeScreen/diary.dart';
import 'package:daenglog_fe/models/homeScreen/category.dart';
import 'package:daenglog_fe/models/homeScreen/weather.dart';

// 토큰 저장소 패키지

// 프로필 패키지
import 'package:daenglog_fe/api/homeScreen/profile_detail_api.dart';
import 'package:daenglog_fe/models/homeScreen/profile.dart';

// 날씨 패키지

// 홈 메인 화면 위젯
class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  String selectedKeyword = "전체"; // 기본값
  Profile? _profile; // 프로필 정보 변수

  // 날씨 상태에 따른 이모지 반환
  String _getWeatherEmoji(String weather) {
    switch (weather) {
      case '맑음':
      case '맑은':
        return '☀️';
      case '흐림':
      case '구름':
        return '☁️';
      case '비':
      case '소나기':
      case '가을비':
        return '🌧️';
      case '눈':
      case '폭설':
        return '❄️';
      case '안개':
      case '짙은안개':
        return '🌫️';
      case '천둥번개':
      case '번개':
        return '⛈️';
      case '우박':
        return '🧊';
      case '황사':
      case '미세먼지':
        return '🌪️';
      case '더움':
      case '폭염':
        return '🔥';
      case '추움':
      case '한파':
        return '🥶';
      default:
        return '🌤️';
    }
  }

  // 날씨 상태에 따른 설명 반환
  String _getWeatherDescription(String weather) {
    switch (weather) {
      case '맑음':
      case '맑은':
        return '산책하기 완벽한 날씨!';
      case '흐림':
      case '구름':
        return '산책하기 좋은 날씨';
      case '비':
      case '소나기':
      case '가을비':
        return '우산과 레인코트 필수!';
      case '눈':
      case '폭설':
        return '미끄러지지 않게 조심하세요';
      case '안개':
      case '짙은안개':
        return '시야가 좋지 않아요';
      case '천둥번개':
      case '번개':
        return '실내에서만 놀아주세요';
      case '우박':
        return '위험하니 실내에서만!';
      case '황사':
      case '미세먼지':
        return '마스크 착용 필수!';
      case '더움':
      case '폭염':
        return '시원한 곳에서만 산책하세요';
      case '추움':
      case '한파':
        return '따뜻하게 입고 나가세요';
      default:
        return '산책하기 좋은 날씨';
    }
  }

  // 디폴트 프로필 정보 가져오기
  Future<Profile> _getProfile() async {
    final profile = await ProfileDetailApi().getProfile();
    setState(() {
      _profile = profile;
    });
    return profile;
  }

  @override
  void initState() {
    super.initState();
    _getProfile(); // Load profile data when screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600), // 배경 변경 (둥근 모서리 효과 보이게)
      body: Column(
        children: [
          // 상단 오렌지 배경 + 강아지 사진 + 텍스트 (고정 영역)
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6600),
            ),
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 4),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 56,
                    backgroundImage:
                        AssetImage('assets/images/home/mango_image.png'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_profile?.petName}의 하루',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 8),
                      const Text('기분 | 🥰 최고',
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      // 날씨 정보를 동적으로 표시
                      FutureBuilder<Weather>(
                        future: WeatherApi().getWeather(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final weather = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('날씨 | ${_getWeatherEmoji(weather.weather)} ${_getWeatherDescription(weather.weather)}',
                                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text('${weather.location} (${_getWeatherEmoji(weather.weather)}${weather.weather}, 미세먼지 ${weather.airQuality})',
                                    style: const TextStyle(color: Colors.white, fontSize: 12)),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink(); // 데이터 로딩 중 빈 공간 처리
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox.shrink(),
              ],
            ),
          ),

          // 스크롤 가능한 영역 (오늘의 망고의 기분은 어떤가요? 부터)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopSectionWidget(),
                  MiddleSectionWidget(profile: _profile),
                  BottomSectionWidget(),
                ]
              )
            ),
          ),
        ],
      ),
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: 0,
      ),
    );
  }
}

