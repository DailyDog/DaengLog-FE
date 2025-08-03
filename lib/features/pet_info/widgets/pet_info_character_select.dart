import 'package:flutter/material.dart';

// 반려동물 성격 태그 선택 위젯
class PetInfoCharacterSelect extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PetInfoCharacterSelect({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40, // 고정 높이 설정
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3EC) : const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF5F01) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFF5C5C5C),
            ),
          ),
        ),
      ),
    );
  }
}