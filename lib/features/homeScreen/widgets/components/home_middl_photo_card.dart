import 'package:flutter/material.dart';

// 메인화면 포토카드 위잿
class HomeMiddlePhotoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String keyword;

  const HomeMiddlePhotoCard({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.keyword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');

    return Container(
      width: 140,
      height: 140, // 정방형 카드
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 배경 이미지
            isNetworkImage
                ? Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),

            // 살짝 어두운 오버레이
            Container(
              color: Colors.black.withOpacity(0.25),
            ),

            // 내용
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 우측 상단 날짜
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      date,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 해시태그/키워드
                  if (keyword.isNotEmpty)
                    Text(
                      '#$keyword',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Pretendard',
                        fontSize: 12,
                      ),
                    ),
                  const SizedBox(height: 4),
                  // 제목
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
