import 'package:flutter/material.dart';

/// 앨범 상세 페이지 앱바 위젯
/// 
/// 앨범 상세 화면의 상단 헤더를 담당합니다.
/// - 일반 모드: 앨범 이름 표시, "선택" 버튼
/// - 선택 모드: "선택" 제목, "전체 선택/선택 해제" 버튼, "취소" 버튼
/// 
/// Figma 디자인: 4-1.1-4 앨범 상세 페이지 (앱바)
class AlbumDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 앨범 이름 (일반 모드일 때 표시)
  final String albumName;
  
  /// 선택 모드 활성화 여부
  final bool isSelectionMode;
  
  /// 선택된 항목 개수
  final int selectedCount;
  
  /// 뒤로가기 버튼 콜백
  final VoidCallback onBack;
  
  /// 선택 모드 진입 버튼 콜백
  final VoidCallback onSelect;
  
  /// 선택 모드 취소 버튼 콜백
  final VoidCallback onCancel;
  
  /// Plus Circle 아이콘 클릭 콜백 (날짜별 정렬 화면으로 이동)
  final VoidCallback? onPlusTap;
  
  /// 전체 선택 버튼 콜백 (선택 모드일 때)
  final VoidCallback? onSelectAll;
  
  /// 전체 선택 해제 버튼 콜백 (선택 모드일 때)
  final VoidCallback? onDeselectAll;

  const AlbumDetailAppBar({
    super.key,
    required this.albumName,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onBack,
    required this.onSelect,
    required this.onCancel,
    this.onPlusTap,
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
        // 일반 모드: Plus Circle 아이콘 + "선택" 버튼 (우측)
        if (!isSelectionMode) ...[
          // Plus Circle 아이콘 (날짜별 정렬 화면으로 이동)
          if (onPlusTap != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
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
                onTap: onSelect, // 선택 모드로 진입
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFFF5F01), // 주황색 테두리
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(17), // 둥근 모서리
                  ),
                  child: const Text(
                    '선택',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF5F01), // 주황색 텍스트
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]
        else
          // 선택 모드: "전체 선택/선택 해제" 버튼 (좌측)
          // Figma 디자인: 검정 배경(전체 선택) / 회색 배경(선택 해제)
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
                    // 선택된 항목이 있으면 회색, 없으면 검정
                    color: selectedCount > 0
                        ? const Color(0xFFDEDEDE) // 회색
                        : Colors.black, // 검정
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    selectedCount > 0 ? '선택 해제' : '전체 선택',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selectedCount > 0
                          ? const Color(0xFF272727) // 회색 배경일 때 검정 텍스트
                          : Colors.white, // 검정 배경일 때 흰색 텍스트
                    ),
                  ),
                ),
              ),
            ),
          ),
        // 선택 모드: "취소" 버튼 (우측)
        // Figma 디자인: 회색 배경의 둥근 버튼
        if (isSelectionMode)
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: GestureDetector(
                onTap: onCancel, // 선택 모드 취소
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEDEDE), // 회색 배경
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF272727), // 검정 텍스트
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

