import 'package:flutter/material.dart';
import '../models/album_photo_item.dart';

class AlbumPhotoGrid extends StatelessWidget {
  final int albumId;
  final bool isSelectionMode;
  final Set<int> selectedItems;
  final Function(int) onItemTap;
  final Function(int) onItemLongPress;

  const AlbumPhotoGrid({
    super.key,
    required this.albumId,
    required this.isSelectionMode,
    required this.selectedItems,
    required this.onItemTap,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: API 연결 시 실제 데이터로 교체
    // 임시 더미 데이터
    final dummyPhotos = _generateDummyPhotos();

    if (dummyPhotos.isEmpty) {
      return const Center(
        child: Text(
          '앨범이 비어있습니다',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
            color: Color(0xFF999999),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(31, 0, 31, 100),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: dummyPhotos.length,
        itemBuilder: (context, index) {
          final photo = dummyPhotos[index];
          final isSelected = selectedItems.contains(photo.id);

          return _AlbumPhotoItem(
            photo: photo,
            isSelected: isSelected,
            isSelectionMode: isSelectionMode,
            onTap: () => onItemTap(photo.id),
            onLongPress: () => onItemLongPress(photo.id),
          );
        },
      ),
    );
  }

  // 임시 더미 데이터 생성
  List<AlbumPhotoItem> _generateDummyPhotos() {
    return [
      AlbumPhotoItem(
        id: 0,
        imageUrl: null, // TODO: 실제 이미지 URL로 교체
        category: '산책',
        count: 23,
      ),
      AlbumPhotoItem(
        id: 1,
        imageUrl: null,
        category: '산책',
        count: 23,
      ),
      AlbumPhotoItem(
        id: 2,
        imageUrl: null,
        category: '간식',
        count: 23,
      ),
      AlbumPhotoItem(
        id: 3,
        imageUrl: null,
        category: '놀이',
        count: 23,
      ),
    ];
  }
}

class _AlbumPhotoItem extends StatelessWidget {
  final AlbumPhotoItem photo;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _AlbumPhotoItem({
    required this.photo,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = (screenWidth - 62 - 32) / 3; // 패딩과 간격 고려

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        children: [
          // 사진 컨테이너
          Container(
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color(0xFFF5F5F5),
              border: isSelectionMode && isSelected
                  ? Border.all(
                      color: const Color(0xFFFF5F01),
                      width: 3,
                    )
                  : null,
              // TODO: 실제 이미지 URL이 있을 때
              // image: photo.imageUrl != null
              //     ? DecorationImage(
              //         image: NetworkImage(photo.imageUrl!),
              //         fit: BoxFit.cover,
              //       )
              //     : null,
            ),
            child: photo.imageUrl == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE0E0E0),
                          const Color(0xFFD0D0D0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: itemSize * 0.4,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      photo.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
          ),
          // 카테고리명 오버레이
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                photo.category,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // 카운트 배지
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.71),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Text(
                photo.count.toString(),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ),
          // 선택 모드 체크박스
          if (isSelectionMode)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Colors.black
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? Colors.black
                        : Colors.white,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

