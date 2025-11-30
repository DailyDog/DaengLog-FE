import 'package:flutter/material.dart';

/// 초대 코드 표시 위젯
/// 
/// 초대 코드를 표시하고 복사할 수 있는 위젯입니다.
/// Figma 디자인: 4-4-2 초대 코드 전송 (코드 표시)
class InviteCodeDisplay extends StatelessWidget {
  /// 초대 코드
  final String code;
  
  /// 복사 버튼 클릭 콜백
  final VoidCallback onCopy;

  const InviteCodeDisplay({
    super.key,
    required this.code,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDAD0), // 연한 주황색 배경
        borderRadius: BorderRadius.circular(110), // 둥근 모서리
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 초대 코드 텍스트
          Text(
            code,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2E2E2E),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // 복사 아이콘
          GestureDetector(
            onTap: onCopy,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.copy,
                size: 16,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

