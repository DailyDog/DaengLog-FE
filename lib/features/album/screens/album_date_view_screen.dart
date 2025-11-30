import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/album_date_view_app_bar.dart';
import '../widgets/album_date_photo_list.dart';
import '../widgets/album_date_filter_bar.dart';

/// 앨범 날짜별 정렬 화면
/// 
/// 앨범의 사진들을 날짜별로 그룹화하여 보여주는 화면입니다.
/// - 날짜 헤더와 함께 사진들을 표시
/// - 일/월/년 단위로 필터링 가능
/// - 4열 그리드 레이아웃
/// 
/// Figma 디자인: 4-1.1-5 앨범 접속 (일 기준)
class AlbumDateViewScreen extends StatefulWidget {
  /// 앨범 ID
  final int albumId;
  
  /// 앨범 이름 (예: "산책", "간식", "놀이")
  final String albumName;

  const AlbumDateViewScreen({
    super.key,
    required this.albumId,
    required this.albumName,
  });

  @override
  State<AlbumDateViewScreen> createState() => _AlbumDateViewScreenState();
}

class _AlbumDateViewScreenState extends State<AlbumDateViewScreen> {
  /// 현재 선택된 날짜 필터 단위
  /// 'day': 일 기준
  /// 'month': 월 기준
  /// 'year': 년 기준
  String _dateFilter = 'day';
  
  /// 선택 모드 활성화 여부
  bool _isSelectionMode = false;
  
  /// 선택된 사진 아이템 ID 집합
  final Set<int> _selectedItems = <int>{};

  /// 날짜 필터 변경
  /// [filter]: 'day', 'month', 'year' 중 하나
  void _changeDateFilter(String filter) {
    setState(() {
      _dateFilter = filter;
      // 필터 변경 시 선택 항목 초기화
      _selectedItems.clear();
    });
  }

  /// 선택 모드 토글
  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  /// 개별 사진 선택/해제 토글
  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  /// 전체 선택
  void _selectAll() {
    setState(() {
      // TODO: 실제 데이터 개수 기반으로 구현 필요
      for (int i = 0; i < 12; i++) {
        _selectedItems.add(i);
      }
    });
  }

  /// 전체 선택 해제
  void _deselectAll() {
    setState(() {
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 앱바: 앨범 이름, Plus Circle 아이콘, 선택 버튼
      appBar: AlbumDateViewAppBar(
        albumName: widget.albumName,
        isSelectionMode: _isSelectionMode,
        selectedCount: _selectedItems.length,
        onBack: () {
          // 뒤로가기: 네비게이션 스택의 이전 페이지로 돌아감
          // context.push()를 사용했으므로 이전 화면(앨범 상세)이 스택에 쌓여있어야 함
          context.pop();
        },
        onPlusTap: () {
          // TODO: 추가하기 기능 구현
        },
        onSelect: _toggleSelectionMode,
        onCancel: _toggleSelectionMode,
        onSelectAll: _selectAll,
        onDeselectAll: _deselectAll,
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠: 날짜별 사진 리스트
          AlbumDatePhotoList(
            albumId: widget.albumId,
            dateFilter: _dateFilter, // 현재 선택된 필터 전달
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
          // 하단 날짜 필터 바
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: AlbumDateFilterBar(
              initialFilter: _dateFilter,
              onFilterChanged: _changeDateFilter,
            ),
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

  /// 선택 모드 하단 액션 바 위젯
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
              _buildActionButton(
                label: '복제',
                onTap: () {
                  // TODO: 복제 기능 구현
                },
              ),
              const SizedBox(width: 6),
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

  /// 액션 버튼 위젯 생성
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

