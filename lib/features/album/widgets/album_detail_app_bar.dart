import 'package:flutter/material.dart';

class AlbumDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String albumName;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onBack;
  final VoidCallback onSelect;
  final VoidCallback onCancel;
  final VoidCallback? onSelectAll;
  final VoidCallback? onDeselectAll;

  const AlbumDetailAppBar({
    super.key,
    required this.albumName,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onBack,
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
        if (!isSelectionMode)
          // 선택 모드 진입 버튼
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
          )
        else
          // 선택 모드일 때 왼쪽: 전체 선택/해제 버튼
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
        if (isSelectionMode)
          // 선택 모드일 때 오른쪽: 취소 버튼
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
    );
  }
}

