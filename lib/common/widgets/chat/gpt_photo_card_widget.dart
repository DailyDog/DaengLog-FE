import 'package:daenglog_fe/api/login/login_api.dart';
import 'package:flutter/material.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';
import 'package:daenglog_fe/utils/secure_token_storage.dart';
import 'package:daenglog_fe/common/widgets/others/login_modal.dart';

class GptPhotoCardWidget extends StatelessWidget {
  final String formattedDate;
  final GptResponse? gptResponse;

  const GptPhotoCardWidget({
    Key? key,
    required this.formattedDate,
    required this.gptResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gptResponse == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽 동그란 아이콘
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F3),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF6600), width: 2),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/home/daeng.png', // 사용자 프로필 이미지로 교체
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 오른쪽 카드
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF5F01), width: 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${gptResponse!.title} 🦴",
                        style: const TextStyle(
                          fontFamily: 'Suite-ExtraBold',
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 본문
                Text(
                  gptResponse!.content.replaceAll("\n", " "), // null이 아님 보장 + 빈 문자열 처리 + 본문 
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'Yeongdeok-Sea',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 16),
                // 포토카드 보기 버튼
                SizedBox(
                  height: 30,
                  width: 110,
                  child: OutlinedButton(
                    onPressed: () async {
                      // 토큰 체크
                      final token = await SecureTokenStorage.getToken();
                      if (token == null || token.isEmpty) {
                        // 토큰이 없으면 로그인 모달 띄우기
                        await showLoginModal(context);
                      } else {
                        // 토큰이 있으면 포토카드 페이지로 이동
                        Navigator.pushNamed(context, '/chat_photo', arguments: gptResponse);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEEE8),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '포토카드 보기',
                          style: TextStyle(
                            color: Color(0xFF5C5C5C),
                            fontFamily: 'Suite-Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward_ios, size: 15, color: Color(0xFF5C5C5C)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}