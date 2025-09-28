import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';

/// 공용 하단 네비게이션 바
Widget commonBottomNavBar({
  required BuildContext context,
  int currentIndex = 0,
}) {
  // 화면 크기 가져오기
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  
  // 아이콘과 라벨 정의
  const items = [
    _NavBarItem(
      iconPath: 'assets/images/home/home_icon.png'
    ),
    _NavBarItem(
      iconPath: 'assets/images/home/record_icon.png'
    ),
    _NavBarItem(
      iconPath: 'assets/images/home/camera_icon.png'
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
        context.go('/home');
        break;
      case 1:
        context.go('/record');
        break;
      case 2:
        Provider.of<RecordProvider>(context, listen: false).takePhotoWithCamera(context);
        break;
      case 3:
        context.go('/close');
        break;
      case 4:
        context.go('/mypage');
        break;
    }
  }

  return Container(
    color: backgroundColor,
    padding: EdgeInsets.only(
      top: screenHeight * 0.012, // 화면 높이의 1.2%
      bottom: screenHeight * 0.01, // 화면 높이의 1%
    ),
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
                width: screenWidth * 0.14, // 화면 너비의 14%
                height: screenWidth * 0.14, // 화면 너비의 14%
                color: selected ? selectedColor : unselectedColor,
              ),
              SizedBox(height: screenHeight * 0.02), // 화면 높이의 5%
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
