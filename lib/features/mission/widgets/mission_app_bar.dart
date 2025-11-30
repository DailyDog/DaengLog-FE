import 'package:flutter/material.dart';

/// 미션 화면 앱바 위젯
/// 
/// 미션 화면의 상단 헤더를 담당합니다.
/// - 뒤로가기 버튼
/// - "미션" 제목
/// - 우측 상단 코인 표시 (100C)
/// 
/// Figma 디자인: 2-2-3 미션 화면 (앱바)
class MissionAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// 뒤로가기 버튼 콜백
  final VoidCallback onBack;

  const MissionAppBar({
    super.key,
    required this.onBack,
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
      title: const Text(
        '미션',
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E2E2E),
        ),
      ),
      centerTitle: true,
      actions: [
        // 우측 상단 코인 표시
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Row(
            children: [
              // 코인 아이콘 (원형)
              Container(
                width: 15,
                height: 15,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF5F01),
                ),
                child: const Icon(
                  Icons.circle,
                  size: 10,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              // 코인 수
              const Text(
                '100C',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF5F01),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

