import 'package:flutter/material.dart';

/// 앨범 날짜 필터 바 위젯
/// 
/// 하단에 표시되는 날짜 필터 선택 바입니다.
/// 일/월/년 단위로 앨범 사진을 필터링할 수 있습니다.
/// 
/// Figma 디자인: 4-1.1-5 앨범 접속 (일 기준) (하단 필터 바)
class AlbumDateFilterBar extends StatefulWidget {
  /// 초기 선택된 필터 ('day', 'month', 'year')
  final String? initialFilter;
  
  /// 필터 변경 콜백
  final Function(String)? onFilterChanged;

  const AlbumDateFilterBar({
    super.key,
    this.initialFilter,
    this.onFilterChanged,
  });

  @override
  State<AlbumDateFilterBar> createState() => _AlbumDateFilterBarState();
}

class _AlbumDateFilterBarState extends State<AlbumDateFilterBar> {
  /// 현재 선택된 필터 ('day', 'month', 'year')
  late String _selectedFilter;

  @override
  void initState() {
    super.initState();
    // 초기 필터 설정 (기본값: 'day')
    _selectedFilter = widget.initialFilter ?? 'day';
  }

  /// 필터 변경
  void _changeFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    // 콜백 호출
    widget.onFilterChanged?.call(filter);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 210, // Figma 디자인 기준 너비
        height: 42, // Figma 디자인 기준 높이
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF8C8B8B),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(58.58), // Figma 디자인 기준
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 일 (Day) 버튼
            Expanded(
              child: _buildFilterButton(
                label: '일',
                filter: 'day',
                isSelected: _selectedFilter == 'day',
                onTap: () => _changeFilter('day'),
              ),
            ),
            // 구분선 (첫 번째)
            Container(
              width: 1,
              height: 12,
              color: const Color(0xFF8C8B8B),
            ),
            // 월 (Month) 버튼
            Expanded(
              child: _buildFilterButton(
                label: '월',
                filter: 'month',
                isSelected: _selectedFilter == 'month',
                onTap: () => _changeFilter('month'),
              ),
            ),
            // 구분선 (두 번째)
            Container(
              width: 1,
              height: 12,
              color: const Color(0xFF8C8B8B),
            ),
            // 년 (Year) 버튼
            Expanded(
              child: _buildFilterButton(
                label: '년',
                filter: 'year',
                isSelected: _selectedFilter == 'year',
                onTap: () => _changeFilter('year'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 필터 버튼 위젯 생성
  /// 
  /// [label]: 버튼 텍스트 ('일', '월', '년')
  /// [filter]: 필터 값 ('day', 'month', 'year')
  /// [isSelected]: 선택 여부
  /// [onTap]: 버튼 클릭 콜백
  Widget _buildFilterButton({
    required String label,
    required String filter,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25, // Figma 디자인 기준 높이
        width: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF5F01) // 선택됨: 주황색 배경
              : Colors.transparent, // 선택 안됨: 투명
          borderRadius: BorderRadius.circular(23.43),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white // 선택됨: 흰색 텍스트
                : const Color(0xFF000000), // 선택 안됨: 검정 텍스트
          ),
        ),
      ),
    );
  }
}

