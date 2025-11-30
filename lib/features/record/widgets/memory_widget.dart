import 'package:flutter/material.dart';

class MemoryWidget extends StatelessWidget {
  const MemoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final margin = 20 * scale;
    final padding = 16 * scale;
    final titleFont = (18 * scale).clamp(16.0, 20.0);

    // 정적 더미 데이터 생성
    final dummyDiary = _createDummyDiary();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: _buildMemoryCard(
          dummyDiary, padding, titleFont, scale, context),
    );
  }

  /// 정적 더미 일기 데이터 생성
  /// TODO: 나중에 API 연결 시 제거하고 실제 데이터 사용
  _DummyDiary _createDummyDiary() {
    return _DummyDiary(
      title: '🐾 조심스러운 간식 시간 🦴',
      content:
          '오늘도 내 자리에서 푹신푹신한 담요 위에 누웠다. 세상에서 제일 편한 이 자리, 누구도 침범할 수 없다. 근데...',
      imageUrl: null, // 이미지가 없으면 플레이스홀더 표시
      date: '2025.01.15',
    );
  }

  Widget _buildMemoryCard(_DummyDiary diary, double padding, double titleFont,
      double scale, BuildContext context) {
    final hasImage = diary.imageUrl != null && diary.imageUrl!.isNotEmpty;
    final contentPreview = diary.content.length > 60
        ? '${diary.content.substring(0, 60)}...'
        : diary.content;

    return GestureDetector(
      onTap: () {
        // TODO: 일기 상세 화면으로 이동 (API 연결 시 구현)
        // context.go('/diary-detail/${diary.id}');
      },
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Memory title with icon
            Row(
              children: [
                Text(
                  '추억',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: titleFont,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF272727),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: const Color(0xFF8C8B8B),
                  size: (16 * scale).clamp(14.0, 18.0),
                ),
              ],
            ),

            SizedBox(height: 16 * scale),

            // Memory content
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Memory text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Memory title with bone icon
                      Row(
                        children: [
                          Icon(
                            Icons.pets,
                            size: (16 * scale).clamp(14.0, 18.0),
                            color: const Color(0xFFFF5F01),
                          ),
                          SizedBox(width: 4 * scale),
                          Expanded(
                            child: Text(
                              diary.title,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: (14 * scale).clamp(12.0, 16.0),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF272727),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8 * scale),

                      // Memory description
                      Text(
                        contentPreview,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: (12 * scale).clamp(10.0, 14.0),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF8C8B8B),
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 8 * scale),

                      // Date (더미 데이터에서는 숨김 처리)
                      // Text(
                      //   diary.date,
                      //   style: TextStyle(
                      //     fontFamily: 'Pretendard',
                      //     fontSize: (10 * scale).clamp(9.0, 12.0),
                      //     fontWeight: FontWeight.w400,
                      //     color: const Color(0xFFCCCCCC),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                SizedBox(width: 16 * scale),

                // Memory photo
                Container(
                  width: (71 * scale).clamp(60.0, 80.0),
                  height: (97 * scale).clamp(80.0, 110.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5F5F5),
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(diary.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasImage
                      ? Center(
                          child: Icon(
                            Icons.auto_stories_outlined,
                            size: (32 * scale).clamp(24.0, 40.0),
                            color: const Color(0xFFCCCCCC),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 정적 더미 일기 데이터 모델
/// TODO: 나중에 API 연결 시 DiaryDetail 모델 사용
class _DummyDiary {
  final String title;
  final String content;
  final String? imageUrl;
  final String date;

  _DummyDiary({
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
  });
}
