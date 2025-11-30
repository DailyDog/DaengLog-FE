import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/api/album/get/album_pet_api.dart';
import 'package:daenglog_fe/api/album/models/album_item.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';
import 'package:go_router/go_router.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final titleLeft = 20 * scale;
    final titleBottom = 16 * scale;
    final listHeight = 140 * scale;
    final listHPadding = 20 * scale;
    final itemGap = 12 * scale;
    final titleFont = (18 * scale).clamp(16.0, 22.0);

    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        if (recordProvider.selectedPet == null) {
          return const SizedBox.shrink();
        }

        final albumsFuture =
            AlbumPetApi().getAlbumsByPet(recordProvider.selectedPet!.id);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Album title with more button
            Padding(
              padding: EdgeInsets.only(left: titleLeft, bottom: titleBottom),
              child: Row(
                children: [
                  Text(
                    '앨범',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: titleFont,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF272727),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.go('/album-more'),
                    child: Row(
                      children: [
                        Text(
                          '더보기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: (14 * scale).clamp(12.0, 16.0),
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                          ),
                        ),
                        SizedBox(width: 4 * scale),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: (12 * scale).clamp(10.0, 14.0),
                          color: Color(0xFF666666),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: titleLeft),
                ],
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
                    return Center(
                      child: Text(
                        '앨범을 불러오지 못했습니다.',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: (14 * scale).clamp(12.0, 16.0),
                          color: Color(0xFF666666),
                        ),
                      ),
                    );
                  }
                  final items = snapshot.data ?? <AlbumItem>[];
                  if (items.isEmpty) {
                    return _buildEmptyState(context, scale);
                  }

                  // 최대 4개까지만 표시
                  final displayItems = items.take(4).toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        for (int i = 0; i < displayItems.length; i++) ...[
                          _AlbumCard(
                            album: displayItems[i],
                            onTap: () => _onAlbumTap(context, displayItems[i]),
                          ),
                          if (i != displayItems.length - 1)
                            SizedBox(width: itemGap),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, double scale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: (40 * scale).clamp(32.0, 48.0),
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 8 * scale),
          Text(
            '아직 앨범이 없습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: (14 * scale).clamp(12.0, 16.0),
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  void _onAlbumTap(BuildContext context, AlbumItem album) {
    // 앨범 상세 페이지로 이동
    context.go('/album-detail/${album.albumId}?name=${Uri.encodeComponent(album.name)}');
  }
}

class _AlbumCard extends StatelessWidget {
  final AlbumItem album;
  final VoidCallback onTap;

  const _AlbumCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = (width / 393.0).clamp(0.8, 1.4);
    final cardW = 100 * scale;
    final cardH = 120 * scale;
    final photoW = 80 * scale;
    final photoH = 80 * scale;
    final badge = 24 * scale;
    final badgeInset = 6 * scale;
    final categoryFont = (13 * scale).clamp(11.0, 15.0);
    final countFont = (10 * scale).clamp(9.0, 12.0);

    final hasUrl = (album.thumbnailImageUrl ?? '').isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardW,
        height: cardH,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Photo container
            Container(
              width: photoW,
              height: photoH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF5F5F5),
                image: hasUrl
                    ? DecorationImage(
                        image: NetworkImage(album.thumbnailImageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  if (!hasUrl)
                    Center(
                      child: Icon(
                        Icons.photo_library_outlined,
                        size: (32 * scale).clamp(24.0, 40.0),
                        color: const Color(0xFFCCCCCC),
                      ),
                    ),
                  // Photo count badge
                  Positioned(
                    bottom: badgeInset,
                    left: badgeInset,
                    child: Container(
                      width: badge,
                      height: badge,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5F01),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF5F01).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          album.imageCount.toString(),
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
            SizedBox(height: 8 * scale),
            // Album name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4 * scale),
              child: Text(
                album.name,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: categoryFont,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF272727),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
