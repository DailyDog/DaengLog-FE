// 바텀 네비게이션 위젯
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
// 홈 메인 위젯 패키지
import 'package:daenglog_fe/features/homeScreen/widgets/home_bottom_section.dart'; // 홈 화면 망고의 일주일 밑 부분 위젯
import 'package:daenglog_fe/features/homeScreen/widgets/home_middle_section.dart'; // 홈 화면 망고의 일주일 영역
import 'package:daenglog_fe/features/homeScreen/widgets/home_top_section.dart'; // 홈 화면 망고의 일주일까지 위젯

// 플러터 위젯 패키지
import 'package:flutter/material.dart';

// dio 패키지
// retrofit 패키지
// json 패키지
// 홈 스크린 패키지
import 'package:daenglog_fe/api/weather/weather_api.dart';
// 모델 패키지
import 'package:daenglog_fe/shared/models/weather.dart';

// 토큰 저장소 패키지

// 프로필 패키지

// 날씨 패키지

// 홈 메인 화면 위젯
class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  String selectedKeyword = "전체"; // 기본값
  late ScrollController _scrollController; // 스크롤 컨트롤러 추가

  // 날씨 상태에 따른 설명 반환

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
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
    final weatherFuture = WeatherApi().getWeather();

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
                          future: weatherFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final weather = snapshot.data!;
                              return Text('오늘 날씨는\n\'${weather.weather}\' 입니다',
                                  style: const TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontFamily: 'Yeongdeok-Sea',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 27,
                                      height: 1.2));
                            } else if (snapshot.hasError) {
                              return Text('날씨 정보를\n불러올 수 없습니다',
                                  style: const TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontFamily: 'Yeongdeok-Sea',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 27,
                                      height: 1.2));
                            } else {
                              return Text('날씨 정보를\n불러오는 중...',
                                  style: const TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontFamily: 'Yeongdeok-Sea',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 27,
                                      height: 1.2));
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
                        HomeTopSection(),
                        // 회색 박스 추가
                        Container(
                          width: double.infinity,
                          height: 8,
                          color: Colors.grey[200],
                        ),
                        HomeMiddleSection(),
                        HomeBottomSection()
                      ]),
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
