import 'package:flutter/material.dart';
import '../models/album_photo_item.dart';
import '../models/album_date_group.dart';

/// 앨범 날짜별 사진 리스트 위젯
/// 
/// 날짜별로 그룹화된 사진들을 표시하는 위젯입니다.
/// - 날짜 헤더와 함께 사진 그리드 표시
/// - 일/월/년 단위로 필터링
/// 
/// Figma 디자인: 4-1.1-5 앨범 접속 (일 기준) (사진 리스트)
class AlbumDatePhotoList extends StatelessWidget {
  /// 앨범 ID
  final int albumId;
  
  /// 날짜 필터 ('day', 'month', 'year')
  final String dateFilter;
  
  /// 선택 모드 활성화 여부
  final bool isSelectionMode;
  
  /// 선택된 사진 아이템 ID 집합
  final Set<int> selectedItems;
  
  /// 사진 아이템 탭 이벤트 콜백
  final Function(int) onItemTap;
  
  /// 사진 아이템 길게 누르기 이벤트 콜백
  final Function(int) onItemLongPress;

  const AlbumDatePhotoList({
    super.key,
    required this.albumId,
    required this.dateFilter,
    required this.isSelectionMode,
    required this.selectedItems,
    required this.onItemTap,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: API 연결 시 실제 데이터로 교체
    // 임시 더미 데이터 (날짜별로 그룹화)
    // dateFilter에 따라 일/월/년 기준으로 데이터를 필터링해야 함
    final dateGroups = _generateDummyDateGroups();

    if (dateGroups.isEmpty) {
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

    // 하단 필터 바와 선택 액션 바 공간 확보 (100px + 79px)
    return Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300), // 전환 애니메이션 지속 시간
        transitionBuilder: (Widget child, Animation<double> animation) {
          // 슬라이드 + 페이드 애니메이션
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0), // 오른쪽에서 살짝
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: ListView.builder(
          key: ValueKey<String>(dateFilter), // 필터 변경 시 새로운 위젯으로 인식
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          itemCount: dateGroups.length,
          itemBuilder: (context, index) {
            final group = dateGroups[index];
            return _DateGroupWidget(
              dateGroup: group,
              dateFilter: dateFilter,
              isSelectionMode: isSelectionMode,
              selectedItems: selectedItems,
              onItemTap: onItemTap,
              onItemLongPress: onItemLongPress,
            );
          },
        ),
      ),
    );
  }

  /// 임시 더미 데이터 생성 (날짜별 그룹)
  /// 
  /// TODO: API 연결 시 제거 필요
  /// API: GET /api/v1/albums/{albumId}
  /// 응답에서 날짜별로 그룹화하여 반환
  List<AlbumDateGroup> _generateDummyDateGroups() {
    return [
      AlbumDateGroup(
        date: '2025.09.16',
        photos: List.generate(12, (index) => AlbumPhotoItem(
          id: index,
          imageUrl: null,
          category: '산책',
          count: 23,
        )),
      ),
      AlbumDateGroup(
        date: '2025.09.13',
        photos: List.generate(8, (index) => AlbumPhotoItem(
          id: index + 12,
          imageUrl: null,
          category: '간식',
          count: 15,
        )),
      ),
      AlbumDateGroup(
        date: '2025.09.12',
        photos: List.generate(4, (index) => AlbumPhotoItem(
          id: index + 20,
          imageUrl: null,
          category: '놀이',
          count: 7,
        )),
      ),
    ];
  }
}

/// 날짜별 그룹 위젯
/// 
/// 하나의 날짜 헤더와 해당 날짜의 사진들을 표시합니다.
class _DateGroupWidget extends StatelessWidget {
  final AlbumDateGroup dateGroup;
  final String dateFilter;
  final bool isSelectionMode;
  final Set<int> selectedItems;
  final Function(int) onItemTap;
  final Function(int) onItemLongPress;

  const _DateGroupWidget({
    required this.dateGroup,
    required this.dateFilter,
    required this.isSelectionMode,
    required this.selectedItems,
    required this.onItemTap,
    required this.onItemLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // 날짜 필터에 따라 열 개수 결정
    // 일(day): 4개, 월(month): 8개, 년(year): 1개
    final crossAxisCount = _getCrossAxisCount(dateFilter);
    
    // 좌우 패딩: 24px * 2 = 48px
    // 열 간격 계산: (crossAxisCount - 1) * 간격
    final spacing = 1.0; // 열 간격
    final totalSpacing = (crossAxisCount - 1) * spacing;
    // 각 아이템 크기: (화면 너비 - 좌우 패딩 - 총 간격) / 열 개수
    final itemSize = (screenWidth - 48 - totalSpacing) / crossAxisCount;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // 그리드 크기 변경 애니메이션
      curve: Curves.easeInOut,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 날짜 헤더
        Padding(
          padding: const EdgeInsets.only(bottom: 9, top: 18),
          child: Text(
            dateGroup.date,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
        ),
        // 사진 그리드 (필터에 따라 열 개수 변경)
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // 필터에 따라 동적으로 변경
            crossAxisSpacing: spacing, // 열 간격
            mainAxisSpacing: spacing, // 행 간격
            childAspectRatio: 1.0, // 정사각형
          ),
          itemCount: dateGroup.photos.length,
          itemBuilder: (context, index) {
            final photo = dateGroup.photos[index];
            final isSelected = selectedItems.contains(photo.id);

            return _AlbumDatePhotoItem(
              key: ValueKey('${photo.id}_$dateFilter'), // 필터별로 고유 키
              photo: photo,
              itemSize: itemSize,
              isSelected: isSelected,
              isSelectionMode: isSelectionMode,
              onTap: () => onItemTap(photo.id),
              onLongPress: () => onItemLongPress(photo.id),
            );
          },
        ),
      ],
      ),
    );
  }

  /// 날짜 필터에 따라 그리드의 열 개수를 반환
  /// 
  /// - 'day': 일 단위 → 4개
  /// - 'month': 월 단위 → 8개
  /// - 'year': 년 단위 → 1개
  int _getCrossAxisCount(String filter) {
    switch (filter) {
      case 'day':
        return 4; // 일 단위: 한 줄에 4개
      case 'month':
        return 8; // 월 단위: 한 줄에 8개
      case 'year':
        return 1; // 년 단위: 한 줄에 1개
      default:
        return 4; // 기본값: 일 단위
    }
  }
}

/// 날짜별 정렬 화면의 개별 사진 아이템 위젯
/// 
/// 4열 그리드에서 사용하는 작은 사진 아이템입니다.
class _AlbumDatePhotoItem extends StatelessWidget {
  final AlbumPhotoItem photo;
  final double itemSize;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _AlbumDatePhotoItem({
    super.key,
    required this.photo,
    required this.itemSize,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // 아이템 크기 변경 애니메이션
        curve: Curves.easeInOut,
        width: itemSize,
        height: itemSize,
        child: Stack(
        children: [
          // 사진 컨테이너
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), // Figma 디자인: 3px 모서리
              color: const Color(0xFFF5F5F5),
              border: isSelectionMode && isSelected
                  ? Border.all(
                      color: const Color(0xFFFF5F01),
                      width: 2,
                    )
                  : null,
            ),
            child: photo.imageUrl == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
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
                        size: itemSize * 0.3,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(3),
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
          // 선택 모드 체크박스 (필요시 추가 가능)
        ],
        ),
      ),
    );
  }
}

