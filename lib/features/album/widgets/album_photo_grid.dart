import 'package:flutter/material.dart';
import '../models/album_photo_item.dart';

/// 앨범 사진 그리드 위젯
/// 
/// 앨범에 포함된 사진들을 3열 그리드 레이아웃으로 표시합니다.
/// - 3열 그리드 레이아웃 (Figma 디자인 기준)
/// - 각 사진에 카테고리명과 카운트 배지 표시
/// - 선택 모드 지원 (체크박스 표시)
/// 
/// Figma 디자인: 4-1.1-4 앨범 상세 페이지 (사진 그리드)
class AlbumPhotoGrid extends StatelessWidget {
  /// 앨범 ID
  final int albumId;
  
  /// 선택 모드 활성화 여부
  final bool isSelectionMode;
  
  /// 선택된 사진 아이템 ID 집합
  final Set<int> selectedItems;
  
  /// 사진 아이템 탭 이벤트 콜백
  final Function(int) onItemTap;
  
  /// 사진 아이템 길게 누르기 이벤트 콜백
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
    // 현재는 임시 더미 데이터 사용
    // API: GET /api/v1/albums/{albumId}
    // 응답: AlbumResponse (diaries 리스트 포함)
    final dummyPhotos = _generateDummyPhotos();

    // 앨범이 비어있는 경우 빈 상태 표시
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

    // 3열 그리드 레이아웃
    // Figma 디자인 기준: 좌우 패딩 31px, 하단 패딩 100px (추가하기 버튼 공간)
    return Padding(
      padding: const EdgeInsets.fromLTRB(31, 0, 31, 100),
      child: GridView.builder(
        // 3열 그리드 설정
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3열
          crossAxisSpacing: 16, // 열 간격
          mainAxisSpacing: 16, // 행 간격
          childAspectRatio: 1.0, // 정사각형 (1:1 비율)
        ),
        itemCount: dummyPhotos.length,
        itemBuilder: (context, index) {
          final photo = dummyPhotos[index];
          final isSelected = selectedItems.contains(photo.id);

          // 각 사진 아이템 위젯
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

  /// 임시 더미 데이터 생성
  /// 
  /// API 연결 전까지 사용하는 더미 데이터입니다.
  /// API 연결 후에는 이 함수를 제거하고 실제 API 응답 데이터를 사용해야 합니다.
  /// 
  /// TODO: API 연결 시 제거 필요
  /// API: GET /api/v1/albums/{albumId}
  /// 응답 형식:
  /// {
  ///   "id": 1,
  ///   "name": "산책",
  ///   "diaryCount": 15,
  ///   "diaries": [
  ///     {
  ///       "id": 123,
  ///       "title": "...",
  ///       "imageUrl": "...",
  ///       "date": "2024-12-15",
  ///       "keywords": ["산책"],
  ///       ...
  ///     }
  ///   ]
  /// }
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

/// 개별 앨범 사진 아이템 위젯
/// 
/// 각 사진을 표시하는 위젯입니다.
/// - 사진 이미지 (또는 플레이스홀더)
/// - 하단 카테고리명 오버레이
/// - 우측 하단 카운트 배지
/// - 선택 모드일 때 좌측 상단 체크박스
/// 
/// Figma 디자인: 4-1.1-4 앨범 상세 페이지 (개별 사진 아이템)
class _AlbumPhotoItem extends StatelessWidget {
  /// 사진 데이터
  final AlbumPhotoItem photo;
  
  /// 선택 여부
  final bool isSelected;
  
  /// 선택 모드 활성화 여부
  final bool isSelectionMode;
  
  /// 탭 이벤트 콜백
  final VoidCallback onTap;
  
  /// 길게 누르기 이벤트 콜백
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
    // 화면 너비에 맞춰 아이템 크기 계산
    // 좌우 패딩: 31px * 2 = 62px
    // 열 간격: 16px * 2 = 32px
    // 따라서 (화면 너비 - 62 - 32) / 3 = 각 아이템 크기
    final screenWidth = MediaQuery.of(context).size.width;
    final itemSize = (screenWidth - 62 - 32) / 3;

    return GestureDetector(
      onTap: onTap, // 일반 탭
      onLongPress: onLongPress, // 길게 누르기
      child: Stack(
        children: [
          // 사진 컨테이너 (메인 이미지 영역)
          Container(
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), // Figma 디자인: 5px 모서리
              color: const Color(0xFFF5F5F5), // 플레이스홀더 배경색
              // 선택 모드이고 선택된 경우 주황색 테두리
              border: isSelectionMode && isSelected
                  ? Border.all(
                      color: const Color(0xFFFF5F01), // 주황색 테두리
                      width: 3,
                    )
                  : null,
            ),
            // 이미지 URL이 없을 때: 플레이스홀더 표시
            // TODO: 실제 이미지 URL로 교체 필요 (API 연결 시)
            child: photo.imageUrl == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // 그라데이션 배경 (플레이스홀더)
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
                    // 이미지 URL이 있을 때: 네트워크 이미지 표시
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      photo.imageUrl!,
                      fit: BoxFit.cover, // 이미지를 컨테이너에 맞춰 채움
                      errorBuilder: (context, error, stackTrace) {
                        // 이미지 로드 실패 시 에러 표시
                        return Container(
                          color: const Color(0xFFF5F5F5),
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
          ),
          // 카테고리명 오버레이 (하단)
          // Figma 디자인: 하단에 반투명 그라데이션 배경 위에 흰색 텍스트
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
                // 위에서 아래로 투명 -> 반투명 검정 그라데이션
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.5), // 반투명 검정
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                photo.category, // 카테고리명 (예: "산책", "간식", "놀이")
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // 텍스트가 길면 말줄임표
              ),
            ),
          ),
          // 카운트 배지 (우측 하단)
          // Figma 디자인: 흰색 반투명 배경의 작은 배지
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.71), // 흰색 71% 불투명도
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(3),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Text(
                photo.count.toString(), // 카운트 숫자
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                ),
              ),
            ),
          ),
          // 선택 모드 체크박스 (좌측 상단)
          // Figma 디자인: 4-1.1-4-1 앨범 상세 페이지 (선택 모드)
          // 선택 모드일 때만 표시
          if (isSelectionMode)
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                width: 18, // Figma 디자인 기준 크기
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // 원형 체크박스
                  color: isSelected
                      ? Colors.black // 선택됨: 검정 배경
                      : Colors.white, // 선택 안됨: 흰색 배경
                  border: Border.all(
                    color: isSelected
                        ? Colors.black
                        : Colors.white,
                    width: 2,
                  ),
                ),
                // 선택된 경우 체크 아이콘 표시
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

