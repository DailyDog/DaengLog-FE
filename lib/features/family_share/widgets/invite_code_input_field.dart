import 'package:flutter/material.dart';

/// 초대 코드 입력 필드 위젯
/// 
/// 초대 코드를 입력받는 텍스트 필드입니다.
/// - 코드 유효성에 따른 스타일 변경
/// - 체크 아이콘 표시
/// - 주황색 밑줄
/// 
/// Figma 디자인: 4-4-3 초대 코드 입력 (입력 필드)
class InviteCodeInputField extends StatelessWidget {
  /// 텍스트 입력 컨트롤러
  final TextEditingController controller;
  
  /// 코드가 유효한지 여부
  final bool isValid;

  const InviteCodeInputField({
    super.key,
    required this.controller,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 입력 필드
        Row(
          children: [
            // 텍스트 입력 영역
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF2E2E2E),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '초대 코드 입력',
                  hintStyle: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFCCCCCC),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) {
                  // 부모 위젯에서 처리됨
                },
              ),
            ),
            
            // 체크 아이콘 (코드가 유효할 때만 표시)
            if (isValid && controller.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50), // 초록색
                  size: 24,
                ),
              ),
          ],
        ),
        
        // 주황색 밑줄
        Container(
          height: 1,
          color: const Color(0xFFFF5F01),
        ),
      ],
    );
  }
}

