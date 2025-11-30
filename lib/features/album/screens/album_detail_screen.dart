import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/album_detail_app_bar.dart';
import '../widgets/album_photo_grid.dart';
import '../widgets/album_add_button.dart';

class AlbumDetailScreen extends StatefulWidget {
  final int albumId;
  final String albumName;

  const AlbumDetailScreen({
    super.key,
    required this.albumId,
    required this.albumName,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  bool _isSelectionMode = false;
  final Set<int> _selectedItems = <int>{};

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _selectAll() {
    // TODO: 실제 데이터 기반으로 구현
    setState(() {
      // 임시 더미 데이터 (나중에 API 연결 시 수정)
      for (int i = 0; i < 4; i++) {
        _selectedItems.add(i);
      }
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AlbumDetailAppBar(
        albumName: widget.albumName,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onBack: () => context.pop(),
        onSelect: _toggleSelectionMode,
        onCancel: _toggleSelectionMode,
        onSelectAll: _selectAll,
        onDeselectAll: _deselectAll,
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠
          AlbumPhotoGrid(
            albumId: widget.albumId,
            isSelectionMode: _isSelectionMode,
            selectedItems: _selectedItems,
            onItemTap: (itemId) {
              if (_isSelectionMode) {
                _toggleItemSelection(itemId);
              } else {
                // TODO: 사진 상세 화면으로 이동
              }
            },
            onItemLongPress: (itemId) {
              if (!_isSelectionMode) {
                _toggleSelectionMode();
                _toggleItemSelection(itemId);
              }
            },
          ),
          // 하단 추가하기 버튼
          if (!_isSelectionMode)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AlbumAddButton(),
            ),
          // 선택 모드 하단 액션 바
          if (_isSelectionMode && _selectedItems.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildSelectionActionBar(),
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionActionBar() {
    return Container(
      height: 79,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Row(
            children: [
              Text(
                '${_selectedItems.length}개 선택됨',
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF272727),
                ),
              ),
              const Spacer(),
              // 복제 버튼
              _buildActionButton(
                label: '복제',
                onTap: () {
                  // TODO: 복제 기능 구현
                },
              ),
              const SizedBox(width: 6),
              // 삭제 버튼
              _buildActionButton(
                label: '삭제',
                onTap: () {
                  // TODO: 삭제 기능 구현
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 7),
        decoration: BoxDecoration(
          color: isDestructive
              ? const Color(0xFFFF5F01)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          border: isDestructive
              ? null
              : Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDestructive
                ? Colors.white
                : const Color(0xFF272727),
          ),
        ),
      ),
    );
  }
}

