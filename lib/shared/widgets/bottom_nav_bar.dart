import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/record/providers/record_provider.dart';

/// 공용 하단 네비게이션 바
Widget commonBottomNavBar({
  required BuildContext context,
  int currentIndex = 0,
  Function(int)? onTap,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  const iconPaths = [
    'assets/images/home/home_icon.png',
    'assets/images/home/record_icon.png',
    'assets/images/home/camera_icon.png',
    'assets/images/home/market_icon.png',
    'assets/images/home/mypage_icon.png',
  ];

  const selectedColor = Color(0xFFFF5F01);
  const unselectedColor = Color(0xFF999999);
  const backgroundColor = Color(0xFFFCF7F4);

  void handleTap(int index) {
    // 외부에서 전달된 onTap 콜백이 있으면 사용
    if (onTap != null) {
      onTap(index);
    }

    // 기본 네비게이션 로직
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/record');
        break;
      case 2:
        Provider.of<RecordProvider>(context, listen: false)
            .takePhotoWithCamera(context);
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
    decoration: BoxDecoration(
      color: backgroundColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
      border: Border(
        top: BorderSide(
          color: Colors.grey.withOpacity(0.2),
          width: 0.5,
        ),
      ),
    ),
    padding: EdgeInsets.only(
      top: screenHeight * 0.02,
      bottom: screenHeight * 0.02,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(iconPaths.length, (index) {
        final selected = index == currentIndex;

        // 가운데 카메라 버튼 특별 처리 (라벨 없음)
        if (index == 2) {
          return GestureDetector(
            onTap: () => handleTap(index),
            child: Transform.translate(
              offset: const Offset(0, -11), // 위로 8px 올리기
              child: Container(
                width: screenWidth * 0.14,
                height: screenWidth * 0.16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selectedColor,
                  boxShadow: [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: screenWidth * 0.08,
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () => handleTap(index),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: (index == 0 || index == 4) ? screenWidth * 0.005 : 0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  iconPaths[index],
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  colorBlendMode: BlendMode.srcIn,
                  color: selected ? selectedColor : unselectedColor,
                  filterQuality: FilterQuality.high,
                ),
                SizedBox(height: screenHeight * 0.011),
                Text(
                  _getTabLabel(index),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected ? selectedColor : unselectedColor,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

String _getTabLabel(int index) {
  const labels = ['홈', '기록', '카메라', '마켓', '마이'];
  return labels[index];
}
