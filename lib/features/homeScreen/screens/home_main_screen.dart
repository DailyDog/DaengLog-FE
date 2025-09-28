import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
import 'package:daenglog_fe/api/weather/weather_api.dart';
import 'package:daenglog_fe/shared/models/weather.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/home_top_section.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/home_middle_section.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/home_bottom_section.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  Weather? _weather;
  bool _weatherLoading = true;
  late final DraggableScrollableController _sheetController;

  double _minExtent = 0.70;
  double _initialExtent = 0.72;
  double _maxExtent = 0.90;
  double _overlayOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_onSheetChanged);
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    try {
      final profileProvider = context.read<DefaultProfileProvider>();

      await Future.wait([
        _loadWeather(),
        profileProvider.loadProfile(),
      ]);
    } catch (e) {
      debugPrint('Failed to initialize home screen: $e');
    }
  }

  Future<void> _loadWeather() async {
    if (!mounted) return;

    try {
      // 1초 타임아웃 설정
      final weather = await WeatherApi().getWeather().timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          debugPrint('Weather API timeout, using default weather');
          throw TimeoutException(
              'Weather API timeout', const Duration(seconds: 1));
        },
      );

      if (mounted) {
        setState(() {
          _weather = weather;
          _weatherLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load weather: $e');
      if (mounted) {
        setState(() {
          _weatherLoading = false;
        });
      }
    }
  }

  void _onSheetChanged() {
    if (!mounted) return;
    final extent = _sheetController.size;
    final progress =
        ((extent - _minExtent) / (_maxExtent - _minExtent)).clamp(0.0, 1.0);
    final opacity = 0.25 * progress;
    if (opacity != _overlayOpacity && mounted) {
      setState(() => _overlayOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/home/sun.png'),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            // 전체 배경을 SafeArea로 감싸기
            SafeArea(
              child: Column(
                children: [
                  // 배경 이미지가 있는 헤더 영역 (고정 높이)
                  Container(
                    height: screenHeight * 0.25,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_weatherLoading)
                            Text(
                              '날씨 정보를\n불러오는 중...',
                              style: const TextStyle(
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Yeongdeok-Sea',
                                fontWeight: FontWeight.w700,
                                fontSize: 27,
                                height: 1.2,
                              ),
                            )
                          else if (_weather != null)
                            Text(
                              '오늘 날씨는\n\'${_weather!.weather}\' 입니다',
                              style: const TextStyle(
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Yeongdeok-Sea',
                                fontWeight: FontWeight.w700,
                                fontSize: 27,
                                height: 1.2,
                              ),
                            )
                          else
                            Text(
                              '날씨 정보를\n불러올 수 없습니다',
                              style: const TextStyle(
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Yeongdeok-Sea',
                                fontWeight: FontWeight.w700,
                                fontSize: 27,
                                height: 1.2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // 나머지 공간은 DraggableScrollableSheet가 채움
                  Expanded(child: Container()),
                ],
              ),
            ),

            // 헤더를 덮는 딤 오버레이
            IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                color: Colors.black.withOpacity(_overlayOpacity),
              ),
            ),

            // DraggableScrollableSheet - SafeArea 밖에 위치
            DraggableScrollableSheet(
              controller: _sheetController,
              minChildSize: _minExtent,
              initialChildSize: _initialExtent,
              maxChildSize: _maxExtent,
              snap: true,
              snapSizes: const [0.74, 0.85],
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 12,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 9),
                      Container(
                        width: 44,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 88),
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
                                HomeBottomSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // 하단 네비게이션
          ],
        ),
      ),
    );
  }
}
