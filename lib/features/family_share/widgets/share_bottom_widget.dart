import 'package:flutter/material.dart';

class ShareBottomWidget extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSendPressed;
  final int selectedMembersCount;

  const ShareBottomWidget({
    Key? key,
    required this.messageController,
    required this.onSendPressed,
    required this.selectedMembersCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFF5F0), // 연한 주황색 배경
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 메시지 입력 필드
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: TextField(
              controller: messageController,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: '메시지를 입력해 주세요',
                hintStyle: TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF272727),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 전송 버튼
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: selectedMembersCount > 0 ? onSendPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedMembersCount > 0 
                  ? const Color(0xFF666666) 
                  : const Color(0xFFCCCCCC),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                '전송하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selectedMembersCount > 0 ? Colors.white : const Color(0xFF999999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}