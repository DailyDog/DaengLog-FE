import 'package:flutter/material.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';

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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F3),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF6600), width: 2),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/home/daeng.png', // 실제 아이콘 경로로 교체
              width: 32,
              height: 32,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 오른쪽 카드
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF6600), width: 1.5),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Row(
                  children: [
                    const Icon(Icons.pets, color: Color(0xFFFF6600)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "${gptResponse!.title} 🦴",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 본문
                Text(
                  gptResponse!.content,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                // 포토카드 보기 버튼
                SizedBox(
                  width: 160,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/example', arguments: gptResponse);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF7F3),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          '포토카드 보기',
                          style: TextStyle(
                            color: Color(0xFFB85C00),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFB85C00)),
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