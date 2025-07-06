import 'package:flutter/material.dart';

/// 공용 하단 네비게이션 바
Widget commonBottomNavBar({
  required BuildContext context,
  int currentIndex = 0,
}) {
  // 아이콘과 라벨 정의
  const items = [
    _NavBarItem(
      iconPath: 'assets/images/home/home_icon.png'
    ),
    _NavBarItem(
      iconPath: 'assets/images/home/record_icon.png'
    ),
    _NavBarItem(
      iconPath: 'assets/images/home/market_icon.png'
    ),
    _NavBarItem(
      iconPath: 'assets/images/home/mypage_icon.png'
    ),
  ];

  // 색상 정의
  const selectedColor = Color(0xFFF26A1A); // 예쁜 오렌지
  const unselectedColor = Color(0xFF222222);
  const backgroundColor = Color(0xFFFCF7F4); // 연한 배경

  void onTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home_main');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/close');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/close');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/close');
        break;
    }
  }

  return Container(
    color: backgroundColor,
    padding: const EdgeInsets.only(top: 10, bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // 양쪽 여백 균등 분배
      children: List.generate(items.length, (index) {
        final selected = index == currentIndex;
        return GestureDetector(
          onTap: () => onTap(index),
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                items[index].iconPath,
                width: 55,
                height: 55,
                color: selected ? selectedColor : unselectedColor,
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    ),
  );
}

class _NavBarItem {
  final String iconPath;
  const _NavBarItem({required this.iconPath});
}
