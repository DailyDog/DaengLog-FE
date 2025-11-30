import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/album_detail_app_bar.dart';
import '../widgets/album_photo_grid.dart';
import '../widgets/album_add_button.dart';

/// 앨범 상세 페이지 화면
/// 
/// 특정 앨범의 사진들을 그리드 형태로 보여주는 화면입니다.
/// - 앨범 이름을 헤더에 표시
/// - 3열 그리드 레이아웃으로 사진 표시
/// - 선택 모드 지원 (다중 선택 가능)
/// - 하단에 추가하기 버튼 제공
/// 
/// Figma 디자인: 4-1.1-4 앨범 상세 페이지
class AlbumDetailScreen extends StatefulWidget {
  /// 앨범 ID
  final int albumId;
  
  /// 앨범 이름 (예: "산책", "간식", "놀이")
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
  /// 선택 모드 활성화 여부
  /// true일 때: 여러 사진 선택 가능
  /// false일 때: 일반 모드
  bool _isSelectionMode = false;
  
  /// 선택된 사진 아이템 ID 집합
  final Set<int> _selectedItems = <int>{};

  /// 선택 모드 토글
  /// 선택 모드를 켜거나 끕니다.
  /// 선택 모드를 끌 때는 모든 선택 항목을 초기화합니다.
  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      // 선택 모드를 끌 때 선택된 항목 모두 초기화
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  /// 개별 사진 선택/해제 토글
  /// [itemId]: 선택/해제할 사진의 ID
  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        // 이미 선택된 항목이면 해제
        _selectedItems.remove(itemId);
      } else {
        // 선택되지 않은 항목이면 선택
        _selectedItems.add(itemId);
      }
    });
  }

  /// 전체 선택
  /// 앨범의 모든 사진을 선택합니다.
  /// TODO: API 연결 시 실제 데이터 개수 기반으로 구현 필요
  void _selectAll() {
    setState(() {
      // TODO: 실제 데이터 기반으로 구현
      // 현재는 임시로 4개의 더미 데이터만 선택
      // API 연결 후에는 실제 사진 개수만큼 선택하도록 수정 필요
      for (int i = 0; i < 4; i++) {
        _selectedItems.add(i);
      }
    });
  }

  /// 전체 선택 해제
  /// 선택된 모든 사진을 해제합니다.
  void _deselectAll() {
    setState(() {
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 앱바: 앨범 이름, Plus Circle 아이콘, 선택 버튼 등 포함
      appBar: AlbumDetailAppBar(
        albumName: widget.albumName,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onBack: () {
          // 뒤로가기: 네비게이션 스택의 이전 페이지로 돌아감
          // context.push()를 사용했으므로 이전 화면이 스택에 쌓여있어야 함
          context.pop();
        },
        onPlusTap: () {
          // Plus Circle 아이콘 클릭: 날짜별 정렬 화면으로 이동
          context.push(
            '/album-date-view/${widget.albumId}?name=${Uri.encodeComponent(widget.albumName)}',
          );
        },
        onSelect: _toggleSelectionMode, // 선택 모드 진입
        onCancel: _toggleSelectionMode, // 선택 모드 취소
        onSelectAll: _selectAll, // 전체 선택
        onDeselectAll: _deselectAll, // 전체 선택 해제
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠: 사진 그리드
          AlbumPhotoGrid(
            albumId: widget.albumId,
            isSelectionMode: _isSelectionMode,
            selectedItems: _selectedItems,
            // 사진 아이템 탭 이벤트
            onItemTap: (itemId) {
              if (_isSelectionMode) {
                // 선택 모드일 때: 선택/해제 토글
                _toggleItemSelection(itemId);
              } else {
                // 일반 모드일 때: 사진 상세 화면으로 이동 (향후 구현)
                // TODO: 사진 상세 화면으로 이동 기능 구현 필요
              }
            },
            // 사진 아이템 길게 누르기 이벤트
            onItemLongPress: (itemId) {
              // 일반 모드에서 길게 누르면 선택 모드로 전환하고 해당 아이템 선택
              if (!_isSelectionMode) {
                _toggleSelectionMode();
                _toggleItemSelection(itemId);
              }
            },
          ),
          // 하단 추가하기 버튼 (일반 모드일 때만 표시)
          if (!_isSelectionMode)
            const Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AlbumAddButton(),
            ),
          // 선택 모드 하단 액션 바 (선택된 항목이 있을 때만 표시)
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

  /// 선택 모드 하단 액션 바 위젯
  /// 
  /// 선택된 사진 개수를 표시하고, 복제/삭제 액션을 제공합니다.
  /// Figma 디자인: 4-1.1-4-2 앨범 상세 페이지 (하단 액션 바)
  Widget _buildSelectionActionBar() {
    return Container(
      height: 79, // Figma 디자인 기준 높이
      decoration: BoxDecoration(
        color: Colors.white,
        // 상단에 그림자 효과
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
              // 선택된 개수 표시
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
                  // TODO: 선택된 사진들을 복제하는 기능 구현 필요
                  // API: POST /api/v1/albums/{albumId}/diaries/{diaryId}/duplicate
                },
              ),
              const SizedBox(width: 6),
              // 삭제 버튼
              _buildActionButton(
                label: '삭제',
                onTap: () {
                  // TODO: 선택된 사진들을 삭제하는 기능 구현 필요
                  // API: DELETE /api/v1/albums/{albumId}/diaries/{diaryId}
                  // 삭제 전 확인 다이얼로그 표시 필요
                },
                isDestructive: true, // 삭제 버튼은 주황색 배경
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 액션 버튼 위젯 생성
  /// 
  /// [label]: 버튼 텍스트
  /// [onTap]: 버튼 클릭 시 실행될 콜백
  /// [isDestructive]: true일 경우 삭제 버튼 스타일 (주황색 배경)
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

