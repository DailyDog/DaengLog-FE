import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/album/get/album_list_api.dart';
import 'package:daenglog_fe/api/album/models/album_item.dart';


class AlbumWidget extends StatelessWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final albumsFuture = AlbumListApi().getAlbums();
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final titleLeft = 20 * scale;
    final titleBottom = 16 * scale;
    final listHeight = 112 * scale;
    final listHPadding = 27 * scale;
    final itemGap = 16 * scale;
    final titleFont = (18 * scale).clamp(16.0, 22.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Album title
        Padding(
          padding: EdgeInsets.only(left: titleLeft, bottom: titleBottom),
          child: Text(
            '앨범',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: titleFont,
              fontWeight: FontWeight.w700,
              color: Color(0xFF272727),
            ),
          ),
        ),
        
        // Photo grid
        Container(
          alignment: Alignment.centerLeft,
          height: listHeight,
          padding: EdgeInsets.symmetric(horizontal: listHPadding),
          child: FutureBuilder<List<AlbumItem>>(
            future: albumsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('앨범을 불러오지 못했습니다.'));
              }
              final items = snapshot.data ?? <AlbumItem>[];
              if (items.isEmpty) {
                return const SizedBox.shrink();
              }
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    for (int i = 0; i < items.length; i++) ...[
                      _PhotoItem(
                        imageUrl: items[i].thumbnailImageUrl ?? '',
                        category: items[i].name,
                        imageCount: items[i].imageCount.toString(),
                        isSelected: false,
                      ),
                      if (i != items.length - 1) SizedBox(width: itemGap),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final String? imageUrl;
  final String category;
  final String imageCount;
  final bool isSelected;
  
  const _PhotoItem({
    this.imageUrl,
    required this.category,
    required this.imageCount,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final cardW = 92 * scale;
    final cardH = 112 * scale;
    final photoW = 71 * scale;
    final photoH = 72 * scale;
    final badge = 23 * scale;
    final badgeInset = 8 * scale;
    final categoryFont = (12 * scale).clamp(11.0, 14.0);
    final countFont = (10 * scale).clamp(9.0, 12.0);

    final hasUrl = (imageUrl ?? '').isNotEmpty;

    return Container(
      width: cardW,
      height: cardH,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Photo container
          Container(
            width: photoW,
            height: photoH,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              image: hasUrl
                  ? DecorationImage(
                      image: NetworkImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Stack(
              children: [
                // Date overlay
                Positioned(
                  bottom: badgeInset,
                  left: badgeInset,
                  child: Container(
                    width: badge,
                    height: badge,
                    decoration: BoxDecoration(
                      color: Color(0xFF95C6FF),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        imageCount,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: countFont,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Category label
          Text(
            category,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: categoryFont,
              fontWeight: FontWeight.w600,
              color: Color(0xFF272727),
            ),
          ),
        ],
      ),
    );
  }
}
