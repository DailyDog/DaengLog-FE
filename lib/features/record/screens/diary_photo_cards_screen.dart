import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/models/diary_by_pet.dart';

class DiaryPhotoCardsScreen extends StatelessWidget {
  final List<DiaryByPet> diaries;

  const DiaryPhotoCardsScreen({super.key, required this.diaries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기'),
      ),
      backgroundColor: const Color(0xFFF6F7F9),
      body: PageView.builder(
        controller: PageController(viewportFraction: 0.86),
        itemCount: diaries.length,
        itemBuilder: (context, index) {
          final item = diaries[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
            child: _DiaryCard(item: item),
          );
        },
      ),
    );
  }
}

class _DiaryCard extends StatelessWidget {
  final DiaryByPet item;

  const _DiaryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: Container(
                color: Colors.white,
                child: Image.network(
                  item.thumbnailUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets,
                        size: 60, color: Color(0xFFFF6600)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF272727),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                item.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: Color(0xFF3C3C43),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Row(
                children: [
                  Text(
                    item.date,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  const Spacer(),
                  if (item.keywords.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.keywords.first,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


