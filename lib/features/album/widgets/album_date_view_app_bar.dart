import 'package:flutter/material.dart';

/// 앨범 날짜별 정렬 화면 앱바 위젯
/// 
/// 앨범 날짜별 정렬 화면의 상단 헤더를 담당합니다.
/// - 일반 모드: 앨범 이름 표시, Plus Circle 아이콘, "선택" 버튼
/// - 선택 모드: "선택" 제목, "전체 선택/선택 해제" 버튼, "취소" 버튼
/// 
/// Figma 디자인: 4-1.1-5 앨범 접속 (일 기준) (앱바)
class AlbumDateViewAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 앨범 이름
  final String albumName;
  
  /// 선택 모드 활성화 여부
  final bool isSelectionMode;
  
  /// 선택된 항목 개수
  final int selectedCount;
  
  /// 뒤로가기 버튼 콜백
  final VoidCallback onBack;
  
  /// Plus Circle 아이콘 클릭 콜백
  final VoidCallback onPlusTap;
  
  /// 선택 모드 진입 버튼 콜백
  final VoidCallback onSelect;
  
  /// 선택 모드 취소 버튼 콜백
  final VoidCallback onCancel;
  
  /// 전체 선택 버튼 콜백
  final VoidCallback? onSelectAll;
  
  /// 전체 선택 해제 버튼 콜백
  final VoidCallback? onDeselectAll;

  const AlbumDateViewAppBar({
    super.key,
    required this.albumName,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onBack,
    required this.onPlusTap,
    required this.onSelect,
    required this.onCancel,
    this.onSelectAll,
    this.onDeselectAll,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Color(0xFF272727),
          size: 20,
        ),
        onPressed: onBack,
      ),
      title: Text(
        isSelectionMode ? '선택' : albumName,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E2E2E),
        ),
      ),
      centerTitle: true,
      actions: [
        // 일반 모드: Plus Circle 아이콘 + 선택 버튼
        if (!isSelectionMode) ...[
          // Plus Circle 아이콘
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(
                Icons.add_circle,
                color: Color(0xFFFF5F01),
                size: 26,
              ),
              onPressed: onPlusTap,
            ),
          ),
          // 선택 버튼
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: GestureDetector(
                onTap: onSelect,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFF5F01),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Text(
                    '선택',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF5F01),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
        else ...[
          // 선택 모드: 전체 선택/해제 버튼 (좌측)
          Padding(
            padding: const EdgeInsets.only(left: 33),
            child: Center(
              child: GestureDetector(
                onTap: selectedCount > 0 ? onDeselectAll : onSelectAll,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: selectedCount > 0
                        ? const Color(0xFFDEDEDE)
                        : Colors.black,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    selectedCount > 0 ? '선택 해제' : '전체 선택',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selectedCount > 0
                          ? const Color(0xFF272727)
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 선택 모드: 취소 버튼 (우측)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: GestureDetector(
                onTap: onCancel,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEDEDE),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

