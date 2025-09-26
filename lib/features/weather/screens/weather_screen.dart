import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/weather_provider.dart';
import '../widgets/weather_loading.dart';
import '../widgets/weather_error.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading) {
            return const WeatherLoading();
          }

          if (weatherProvider.error != null) {
            return WeatherError(
              message: weatherProvider.error!,
              onRetry: () => weatherProvider.loadWeather(),
            );
          }

          if (weatherProvider.weather == null) {
            return WeatherError(
              message: '날씨 정보를 불러올 수 없습니다.',
              onRetry: () => weatherProvider.loadWeather(),
            );
          }

          return _buildWeatherUI(context, weatherProvider.weather!);
        },
      ),
    );
  }

  Widget _buildWeatherUI(BuildContext context, weather) {
    return Stack(
      children: [
        // 배경 원형 장식들 (블러 효과 포함)
        _buildBackgroundDecorations(),

        // 메인 콘텐츠
        SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 상태바 영역
              SizedBox(height: MediaQuery.of(context).padding.top + 20),

              // 뒤로가기 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 위치 정보
              const Text(
                '정릉동',
                style: TextStyle(
                  fontSize: 22.6,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E2E2E),
                  fontFamily: 'Pretendard',
                ),
              ),

              const SizedBox(height: 20),

              // 오전/오후 날씨 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // 오전 날씨
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            '오전',
                            style: TextStyle(
                              fontSize: 22.6,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E2E2E),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '27.6 ℃',
                            style: TextStyle(
                              fontSize: 21.6,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2E2E2E),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '강수확률',
                                style: TextStyle(
                                  fontSize: 12.6,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2E2E2E),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '20%',
                                style: TextStyle(
                                  fontSize: 12.6,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2E2E2E),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 구분선
                    Container(
                      width: 1,
                      height: 256,
                      color: const Color(0xFFE0E0E0),
                    ),

                    // 오후 날씨
                    Expanded(
                      child: Column(
                        children: [
                          const Text(
                            '오후',
                            style: TextStyle(
                              fontSize: 22.6,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2E2E2E),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            '30.6 ℃',
                            style: TextStyle(
                              fontSize: 21.6,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2E2E2E),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '강수확률',
                                style: TextStyle(
                                  fontSize: 12.6,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2E2E2E),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '10%',
                                style: TextStyle(
                                  fontSize: 12.6,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF2E2E2E),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 미세먼지 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '미세먼지 | ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8C8B8B),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const Text(
                            '보통',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF9900),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '미세먼지 | ',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF8C8B8B),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          const Text(
                            '좋음',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF007AFF),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 날씨 메시지
              const Text(
                '오늘 맑아요',
                style: TextStyle(
                  fontSize: 22.6,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF5F01),
                  fontFamily: 'Pretendard',
                ),
              ),

              const SizedBox(height: 40),

              // 산책 일러스트 (피그마 이미지 사용)
              Center(
                child: Container(
                  width: 235,
                  height: 208,
                  child: Image.asset(
                    'assets/images/weather/walking_dog.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // 로컬 이미지 로드 실패 시 기본 이미지 사용
                      return Image.asset(
                        'assets/images/home/widget/dog_icon.png',
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 산책 메시지
              const Text(
                '망고가 산책 나갈 기분인지 알아볼까요?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8C8B8B),
                  fontFamily: 'Pretendard',
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 100), // 하단 버튼을 위한 여백
            ],
          ),
        ),

        // 하단 고정 버튼
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('산책 미션 기능을 준비 중입니다.'),
                  backgroundColor: Color(0xFFFF5F01),
                ),
              );
            },
            child: Container(
              height: 57,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5F01),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5F01).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '산책 미션 수행하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecorations() {
    return Stack(
      children: [
        // 좌상단 원 (블러 효과)
        Positioned(
          left: -54,
          top: 23,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 우상단 원 (블러 효과)
        Positioned(
          right: -28,
          top: 195,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 좌하단 원 (블러 효과)
        Positioned(
          left: -18,
          bottom: 200,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 우하단 원 (블러 효과)
        Positioned(
          right: -28,
          bottom: 50,
          child: Container(
            width: 201,
            height: 201,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF0F0F0).withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
