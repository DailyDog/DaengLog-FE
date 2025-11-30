import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/api/diary/get/diary_random_api.dart';
import 'package:daenglog_fe/api/diary/models/diary_detail.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';
import 'package:go_router/go_router.dart';

class MemoryWidget extends StatelessWidget {
  const MemoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final margin = 20 * scale;
    final padding = 16 * scale;
    final titleFont = (18 * scale).clamp(16.0, 20.0);

    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        if (recordProvider.selectedPet == null) {
          return const SizedBox.shrink();
        }

        final randomDiaryFuture =
            DiaryRandomApi().getRandomDiary(recordProvider.selectedPet!.id);

        return Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          child: FutureBuilder<DiaryDetail?>(
            future: randomDiaryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingState(padding, titleFont);
              }

              if (snapshot.hasError || snapshot.data == null) {
                // 일기가 없으면 위젯을 숨김
                return const SizedBox.shrink();
              }

              final diary = snapshot.data!;
              return _buildMemoryCard(
                  diary, padding, titleFont, scale, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingState(double padding, double titleFont) {
    return Container(
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
          Text(
            '추억',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: titleFont,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF272727),
            ),
          ),
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildMemoryCard(DiaryDetail diary, double padding, double titleFont,
      double scale, BuildContext context) {
    final hasImage = diary.imageUrl != null && diary.imageUrl!.isNotEmpty;
    final contentPreview = diary.content.length > 60
        ? '${diary.content.substring(0, 60)}...'
        : diary.content;

    return GestureDetector(
      onTap: () => context.go('/diary-detail/${diary.id}'),
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
                // Memory photo (왼쪽)
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

                SizedBox(width: 16 * scale),

                // Memory text content (오른쪽)
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

                      // Date
                      Text(
                        diary.date,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: (10 * scale).clamp(9.0, 12.0),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFCCCCCC),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
