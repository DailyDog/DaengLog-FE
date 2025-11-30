import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/models/diary_by_pet.dart';

class DiaryPhotoCardsScreen extends StatelessWidget {
  final List<DiaryByPet> diaries;
  final int initialPage;

  const DiaryPhotoCardsScreen({
    super.key, 
    required this.diaries,
    this.initialPage = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일기'),
      ),
      backgroundColor: const Color(0xFFF6F7F9),
      body: PageView.builder(
        controller: PageController(
          viewportFraction: 0.86,
          initialPage: initialPage,
        ),
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Material(
      color: Colors.white,
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: screenHeight * 0.85, // 고정 높이로 오버플로우 방지
          child: Container(
            color: Colors.white,
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 화면 크기에 맞는 고해상도 캐싱
                final cacheWidth = (constraints.maxWidth * 3).toInt(); // 3x 해상도로 캐싱
                final cacheHeight = (constraints.maxHeight * 3).toInt();
                
                // 저장된 전체 포토카드 이미지를 그대로 표시 (이미지+제목+텍스트+선 등 모든 요소 포함)
                return Image.network(
                  item.thumbnailUrl,
                  fit: BoxFit.contain, // 비율 유지하며 전체 표시
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  // 고해상도 캐싱으로 화질 개선
                  cacheWidth: cacheWidth,
                  cacheHeight: cacheHeight,
                  filterQuality: FilterQuality.high,
                  isAntiAlias: true,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (c, e, s) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.pets,
                        size: 60, color: Color(0xFFFF6600)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


