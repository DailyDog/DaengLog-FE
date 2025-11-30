import 'package:flutter/material.dart';

/// 구성원 초대 옵션 버튼 위젯
/// 
/// 초대 방식 선택을 위한 버튼입니다.
/// - Primary: 주황색 배경, 흰색 텍스트
/// - Secondary: 흰색 배경, 주황색 테두리, 주황색 텍스트
/// 
/// Figma 디자인: 4-4-1 구성원 초대 메인 (옵션 버튼)
class InviteOptionButton extends StatelessWidget {
  /// 버튼 텍스트
  final String title;
  
  /// Primary 스타일 여부
  /// true: 주황색 배경, 흰색 텍스트
  /// false: 흰색 배경, 주황색 테두리, 주황색 텍스트
  final bool isPrimary;
  
  /// 버튼 클릭 콜백
  final VoidCallback onTap;

  const InviteOptionButton({
    super.key,
    required this.title,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 72, // Figma: 좌우 72px
          vertical: 10, // Figma: 상하 10px
        ),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFFFF5F01) // Primary: 주황색 배경
              : Colors.white, // Secondary: 흰색 배경
          border: isPrimary
              ? null
              : Border.all(
                  color: const Color(0xFFFF5F01), // 주황색 테두리
                  width: 1,
                ),
          borderRadius: BorderRadius.circular(15), // Figma: 15px 모서리
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isPrimary
                  ? Colors.white // Primary: 흰색 텍스트
                  : const Color(0xFFFF5F01), // Secondary: 주황색 텍스트
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

