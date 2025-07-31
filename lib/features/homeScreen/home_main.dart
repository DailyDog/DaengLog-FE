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
import 'package:daenglog_fe/api/weather/weather_api.dart';
// 모델 패키지
import 'package:daenglog_fe/models/homeScreen/diary.dart';
import 'package:daenglog_fe/models/homeScreen/weather.dart';

// 토큰 저장소 패키지

// 프로필 패키지
import 'package:daenglog_fe/api/pets/profile_detail_api.dart';
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
  late ScrollController _scrollController; // 스크롤 컨트롤러 추가
  double _lastScrollPosition = 0.0; // 마지막 스크롤 위치

  // 날씨 상태에 따른 설명 반환


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
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _getProfile(); // Load profile data when screen initializes
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 리스너 - 아래로 스크롤하는 것을 막음
  void _onScroll() {
    // 스크롤이 맨 아래에 도달했을 때 더 이상 아래로 스크롤하지 못하게 함
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      // 이미 맨 아래에 있으면 더 이상 스크롤하지 않음
    }
  }

  // 커스텀 스크롤 물리학 - 위로는 스크롤 가능, 아래로는 스크롤 불가
  ScrollPhysics _getCustomScrollPhysics() {
    return const NeverScrollableScrollPhysics();
  }

  @override
  Widget build(BuildContext context) {

    // 날씨 상태에 따른 배경 이미지 설정
    String backgroundImage = 'assets/images/home/sun.png';
    final weather = WeatherApi().getWeather();
    if(weather == '폭염' || weather == '맑음') {
      backgroundImage = 'assets/images/home/sun.png';
    } else if(weather == '흐림' || weather == '소나기' || weather == '비' || weather == '폭우' || weather == '비/눈') {
      backgroundImage = 'assets/images/home/rain.png';
    } else if(weather == '한파' || weather == '눈' || weather == '눈/비') {
      backgroundImage = 'assets/images/home/snow.png';
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
                SliverAppBar(
                  expandedHeight: 180,
                  centerTitle: false,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent, 
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Weather>(
                            future: weather,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final weather = snapshot.data!;
                                return Text('오늘 날씨는\n\'${weather.weather}\' 입니다',
                                    style: const TextStyle(color: Color(0XFFFFFFFF), fontFamily: 'Yeongdeok-Sea', fontWeight: FontWeight.w700, fontSize: 27, height: 1.2));
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ];
          },
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: CustomScrollView(
              physics: _getCustomScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopSectionWidget(profile: _profile),
                      // 회색 박스 추가
                      Container(
                        width: double.infinity,
                        height: 8,
                        color: Colors.grey[200],
                      ),
                      MiddleSectionWidget(profile: _profile),
                      BottomSectionWidget(profile: _profile)
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
    ),
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: 0,
      ),
    );
  }
}

