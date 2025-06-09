// 바텀 네비게이션 위젯
import 'package:daenglog_fe/common/bottom/home_bottom_nav_bar.dart';
// 홈 메인 위젯 패키지
import 'package:daenglog_fe/common/widgets/home_main.widgets/past_photo_item.dart'; // 과거 사진 위젯
import 'package:daenglog_fe/common/widgets/home_main.widgets/photo_card.dart'; // 사진 카드 위젯
import 'package:daenglog_fe/common/widgets/home_main.widgets/tap_chip.dart'; // 카테고리 탭 위젯
// 홈 화면 패키지
import 'package:daenglog_fe/features/homeScreen/home_prompt_sec.dart';
// 플러터 위젯 패키지
import 'package:flutter/material.dart';

// 홈 메인 화면 위젯
class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600), // 배경 변경 (둥근 모서리 효과 보이게)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 오렌지 배경 + 강아지 사진 + 텍스트
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
                          AssetImage('assets/images/mango_profile.jpg'),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('망고의 하루',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 8),
                        Text('기분 | 🥰 최고',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        Text('날씨 | ☀️ 산책가기 좋음',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(height: 4),
                        Text('서울 성북구 정릉동  (☀️맑음, 미세먼지 좋음)',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

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
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: '오늘 ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            TextSpan(
                              text: '망고',
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
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FractionallySizedBox(
                              heightFactor: 1.0,
                              child: HomePromptSec(),
                            ),
                          );
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
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            // API 요청 이후 입력 될 것
                            TextSpan(
                              text: "망고",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
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
                        child: Row(
                          children: [
                            // for(var i = 0; i < 6; i++)
                            TabChip(label: "전체", selected: true),
                            TabChip(label: "사료", selected: false),
                            TabChip(label: "간식", selected: false),
                            TabChip(label: "산책", selected: false),
                            TabChip(label: "놀이", selected: false),
                            TabChip(label: "의류", selected: false),
                          ],
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // for(var i = 0; i < 2; i++)
                    PhotoCard(
                        imagePath: "assets/images/mango1.jpg",
                        title: "기다려가 뭐야?",
                        date: "12/3"),
                    const SizedBox(width: 12),
                    PhotoCard(
                        imagePath: "assets/images/mango2.jpg",
                        title: "산책이 너무 좋아",
                        date: "12/3"),
                  ],
                ),
              ),
            ),

            // 과거의 망고 영역 (블럭 처리)
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
                        PastPhotoItem(
                            imagePath: "assets/images/mango1.jpg",
                            date: "12/3"),
                        PastPhotoItem(
                            imagePath: "assets/images/mango2.jpg", date: "3/2"),
                        PastPhotoItem(
                            imagePath: "assets/images/mango3.jpg", date: "4/1"),
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
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: 0,
      ),
    );
  }
}
