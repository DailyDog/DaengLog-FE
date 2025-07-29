// 바텀 네비게이션 위젯
import 'package:daenglog_fe/common/widgets/bottom/home_bottom_nav_bar.dart';
// 홈 메인 위젯 패키지
import 'package:daenglog_fe/common/widgets/home_main.widgets/past_photo_item.dart'; // 과거 사진 위젯
import 'package:daenglog_fe/common/widgets/home_main.widgets/photo_card.dart'; // 사진 카드 위젯
import 'package:daenglog_fe/common/widgets/home_main.widgets/tap_chip.dart'; // 카테고리 탭 위젯
// 홈 화면 패키지
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

  // 프로필 이름 가져오기
  String getPetName() {
    return _profile?.petName ?? '코코'; // 디폴트 프로필 이름 망고
  }

  // 프로필 ID 가져오기
  int getPetId() {
    return _profile?.id ?? 2; // 디폴트 프로필 ID 2
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
                      Text('${getPetName()}의 하루',
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
                  // 오늘의 망고의 기분은 어떤가요? 영역
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 타이틀 텍스트 (RichText 사용: 부분 색상 강조)
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '오늘 ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: getPetName(),
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  TextSpan(
                                    text: '의 기분은 어떤가요?',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "사진과 함께 간단한 설명을 첨부해주세요!",
                              style: TextStyle(color: Colors.black54),
                            ),
                            // 프롬프트 창 이동 버튼
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/chat_service');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "ex. 방금 간식주고 찍은 사진",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_forward_ios,
                                        color: Colors.orange),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 망고의 일주일 영역
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  // API 요청 이후 입력 될 것
                                  TextSpan(
                                    text: getPetName(),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "의 일주일",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "일주일동안 망고는 어떻게 지냈을까요?",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: FutureBuilder<List<Category>>(
                                future: CategoryApi().getCategory(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(child: Text('카테고리 불러오기 실'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return const Center(child: Text('카테고리 없음'));
                                  }
                                  
                                  final categories = snapshot.data!;
                                  return Row(
                                    children: [
                                      // "전체" 탭은 항상 첫 번째로 표시
                                      TabChip(
                                        label: "전체",
                                        selected: selectedKeyword == "전체",
                                        onTap: () => setState(() => selectedKeyword = "전체"),
                                      ),
                                      // API에서 받은 카테고리들로 TabChip 생성
                                      ...categories.map((category) => TabChip(
                                        label: category.categoryName,
                                        selected: selectedKeyword == category.categoryName,
                                        onTap: () => setState(() => selectedKeyword = category.categoryName),
                                      )).toList(),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 사진 카드 리스트 (가로 스크롤)
                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      height: 180,
                      child: FutureBuilder<List<Diary>>(
                        future: AlbumDetailApi().getAlbumDetail(keyword: selectedKeyword), // selectedKeyword는 TabChip에서 선택된 값
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('데이터 불러오기 실패'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('데이터 없음'));
                          }

                          final albums = snapshot.data!;
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: albums.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final album = albums[index];
                              return PhotoCard(
                                imagePath: album.thumbnailUrl,
                                title: album.content, // content가 "기다려가 뭐야?" 같은 문구
                                date: album.date,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // 과거의 망고 영역
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text('과거의 망고',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('과거 망고의 속마음을 읽어보세요.',
                            style: TextStyle(color: Colors.black54)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // for(var i = 0; i < 3; i++)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 0), // 하단 네비게이션 공간 확보용
                ],
              ),
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

