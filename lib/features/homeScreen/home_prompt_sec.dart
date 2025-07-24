// 프로젝트 라이브러리
import 'package:daenglog_fe/common/widgets/bottom/home_bottom_nav_bar.dart';
// 플러터 라이브러리
import 'package:flutter/material.dart';
// 날짜 포맷팅 초기화
import 'package:intl/date_symbol_data_local.dart';
// 날짜 포맷팅
import 'package:intl/intl.dart';

class HomePromptSec extends StatelessWidget {
  const HomePromptSec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 날짜 포맷팅 초기화
    initializeDateFormatting('ko_KR');

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F3), // 연한 배경
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        elevation: 0,
        toolbarHeight: 100,
        flexibleSpace: null,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '망고의 생각은..',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 뱃지
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  formattedDate, // 날짜 포맷팅
                  style: TextStyle(
                    color: Color(0xFFFF6600),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 사진 + 설명 버튼
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/home/daeng.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '망고',
                          style: TextStyle(
                            color: Color(0xFFFF6600),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text(
                    '간식주고 찍은 사진',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 일기 카드
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xFFFF6600),
                  width: 1.2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.pets, color: Color(0xFFFF6600)),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '오늘의 일기 - 조심스러운 간식 시간 🦴',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '오늘도 내 자리에서 푹신푹신한 담요 위에 누웠다.\n'
                    '세상에서 제일 편한 이 자리, 누구도 침범할 수 없다.\n'
                    '근데... 간식이 하나 딱! 내 앞에 놓여 있었다.',
                    style: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE5CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '포토카드 보기',
                            style: TextStyle(
                              color: Color(0xFFFF6600),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              size: 16, color: Color(0xFFFF6600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // 텍스트 입력 및 사진 첨부 버튼
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 21, left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(21),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 사진 미리보기
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.close, size: 18, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              // 텍스트 입력
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'ex. 방금 간식주고 찍은 사진',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              // 사진 첨부 버튼
              IconButton(
                icon:
                    const Icon(Icons.image_outlined, color: Color(0xFFFF6600)),
                onPressed: () {},
              ),
              // 전송 버튼
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios,
                    color: Color(0xFFFF6600)),
                onPressed: () {},
              ),
            ],
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
