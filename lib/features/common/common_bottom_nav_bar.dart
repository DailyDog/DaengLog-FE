import 'package:flutter/material.dart';

/// 공용 하단 네비게이션 바
Widget commonBottomNavBar({
  required BuildContext context,
  int currentIndex = 0,
}) {
  // 아이콘과 라벨 정의
  const items = [
    _NavBarItem(
      icon: Icons.home_rounded,
      label: '홈',
    ),
    _NavBarItem(
      icon: Icons.edit_note_rounded,
      label: '기록',
    ),
    _NavBarItem(
      icon: Icons.shopping_bag_rounded,
      label: '마켓',
    ),
    _NavBarItem(
      icon: Icons.person_outline_rounded,
      label: '마이',
    ),
  ];

  // 색상 정의
  const selectedColor = Color(0xFFF26A1A); // 예쁜 오렌지
  const unselectedColor = Color(0xFF222222);
  const backgroundColor = Color(0xFFFCF7F4); // 연한 배경

  void _onTap(int index) {
    // 각 탭에 따라 example.dart로 이동 (예시)
    Navigator.pushReplacementNamed(context, '/example');
  }

  return Container(
    color: backgroundColor,
    padding: const EdgeInsets.only(top: 8, bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (index) {
        final selected = index == currentIndex;
        return GestureDetector(
          onTap: () => _onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                items[index].icon,
                size: 48,
                color: selected ? selectedColor : unselectedColor,
              ),
              const SizedBox(height: 4),
              Text(
                items[index].label,
                style: TextStyle(
                  color: selected ? selectedColor : unselectedColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );
}

class _NavBarItem {
  final IconData icon;
  final String label;
  const _NavBarItem({required this.icon, required this.label});
}
