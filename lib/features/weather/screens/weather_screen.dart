import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_loading.dart';
import '../widgets/weather_error.dart';
import '../widgets/weather_action_button.dart';
import '../widgets/weather_app_bar.dart';
import '../widgets/weather_info_card.dart';
import '../widgets/weather_background.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 반응형 폰트 크기 계산
    final baseFontSize = screenWidth * 0.045; // 화면 너비의 4.5%
    final rainFontSize = screenWidth * 0.035; // 강수확률은 중간 크기

    return Stack(
      children: [
        // 배경 원형 장식들 (블러 효과 포함)
        const WeatherBackground(),

        // 상단 고정 영역 (뒤로가기 버튼 + 위치)
        WeatherAppBar(
          location: weather.location,
          onBackPressed: () => Navigator.of(context).pop(),
          screenWidth: screenWidth,
        ),

        // 메인 콘텐츠 (스크롤 가능)
        Positioned(
          top: MediaQuery.of(context).padding.top + 70, // 상단 고정 영역 아래부터
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // 오전/오후 날씨 정보
                  Row(
                    children: [
                      WeatherInfoCard(
                        title: '오전',
                        weather: weather.morningWeather,
                        screenWidth: screenWidth,
                      ),
                      // 구분선
                      Container(
                        width: 1,
                        height: 240,
                        color: const Color(0xFFE0E0E0),
                      ),
                      WeatherInfoCard(
                        title: '오후',
                        weather: weather.afternoonWeather,
                        screenWidth: screenWidth,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 날씨 메시지
                  Text(
                    weather.weatherMessage,
                    style: TextStyle(
                      fontSize: baseFontSize * 1.5, // 폰트 크기 증가
                      fontWeight: FontWeight.w800, // 굵기 증가
                      color: const Color(0xFFFF5F01),
                      fontFamily: 'Pretendard',
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 산책 일러스트 (우측으로 이동)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: screenWidth * 0.7, // 화면 너비의 60%
                      height: screenHeight * 0.25, // 화면 높이의 25%
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

                  const SizedBox(height: 20),

                  // 산책 메시지
                  Text(
                    '망고가 산책 나갈 기분인지 알아볼까요?',
                    style: TextStyle(
                      fontSize: rainFontSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8C8B8B),
                      fontFamily: 'Pretendard',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.15), // 하단 버튼을 위한 여백
                ],
              ),
            ),
          ),
        ),

        // 하단 고정 버튼 (살짝 아래로 이동)
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 10, // 20 -> 10으로 이동
          left: 20,
          right: 20,
          child: WeatherActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('산책 미션 기능을 준비 중입니다.'),
                  backgroundColor: Color(0xFFFF5F01),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
