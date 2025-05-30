import 'package:daenglog_fe/common/bottom/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

// 홈 메인 화면 위젯
class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 오렌지 배경 + 강아지 사진 + 텍스트
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6600),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
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
            const SizedBox(height: 24),
            // 오늘의 망고의 기분은 어떤가요? 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      Navigator.pushNamed(context, '/home_prompt');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(32),
                        border:
                            Border.all(color: Colors.grey.shade300, width: 2),
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
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
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
            const SizedBox(height: 32),
            // 망고의 일주일 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
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
                        _buildTab("전체", true),
                        _buildTab("사료", false),
                        _buildTab("간식", false),
                        _buildTab("산책", false),
                        _buildTab("놀이", false),
                        _buildTab("의류", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 사진 카드 리스트 (가로 스크롤)
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildPhotoCard(
                      "assets/images/mango1.jpg", "기다려가 뭐야?", "12/3"),
                  const SizedBox(width: 12),
                  _buildPhotoCard(
                      "assets/images/mango2.jpg", "산책이 너무 좋아", "12/3"),
                  // 추가 카드...
                ],
              ),
            ),
            const SizedBox(height: 32),
            // 과거의 망고 영역 (블럭 처리)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
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
                        _buildPastPhoto('assets/images/mango1.jpg', '12/3'),
                        _buildPastPhoto('assets/images/mango2.jpg', '3/2'),
                        _buildPastPhoto('assets/images/mango3.jpg', '4/1'),
                        // ...
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // 하단 네비게이션 공간 확보용
          ],
        ),
      ),
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: 0,
      ),
    );
  }

  // 탭(Chip) 위젯 생성 함수
  Widget _buildTab(String label, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor:
            selected ? Colors.orange : Colors.white, // 선택 여부에 따라 색상 변경
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: selected ? Colors.orange : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  // 사진 카드 위젯 생성 함수
  Widget _buildPhotoCard(String imagePath, String title, String date) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPastPhoto(String imagePath, String date) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
