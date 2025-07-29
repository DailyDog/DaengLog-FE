// 망고의 일주일 영역
import 'package:flutter/material.dart';

class MiddleSectionWidget extends StatelessWidget {
  const MiddleSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첫 번째 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: getPetName(),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const TextSpan(
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
                    child: FutureBuilder<List<Category>>(
                      future: CategoryApi().getCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(child: Text('카테고리 불러오기 실'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('카테고리 없음'));
                        }

                        final categories = snapshot.data!;
                        return Row(
                          children: [
                            TabChip(
                              label: "전체",
                              selected: selectedKeyword == "전체",
                              onTap: () => setState(() => selectedKeyword = "전체"),
                            ),
                            ...categories.map(
                              (category) => TabChip(
                                label: category.categoryName,
                                selected: selectedKeyword == category.categoryName,
                                onTap: () => setState(
                                  () => selectedKeyword = category.categoryName,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 두 번째 영역
        Container(
          color: Colors.white,
          child: SizedBox(
            height: 180,
            child: FutureBuilder<List<Diary>>(
              future: AlbumDetailApi().getAlbumDetail(keyword: selectedKeyword),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('데이터 불러오기 실패'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('데이터 없음'));
                }

                final albums = snapshot.data!;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: albums.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final album = albums[index];
                    return PhotoCard(
                      imagePath: album.thumbnailUrl,
                      title: album.content,
                      date: album.date,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}