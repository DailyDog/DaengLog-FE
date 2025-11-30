import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';

class PetHorizontalList extends StatelessWidget {
  final List<PetListItem> pets;
  final int? selectedPetId;
  final void Function()? onEditTap;

  const PetHorizontalList({
    super.key,
    required this.pets,
    required this.selectedPetId,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '내 반려동물',
              style: TextStyle(
                fontSize: screenWidth * 0.052, // 더 두껍고 약간 크게
                fontWeight: FontWeight.w800,
                color: const Color(0xFF484848),
              ),
            ),
            GestureDetector(
              onTap: onEditTap,
              child: Row(
                children: [
                  Text(
                    '수정',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9A9A9A),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Icon(
                    Icons.chevron_right, // 우측 화살표 방향 유지
                    size: screenWidth * 0.048,
                    color: const Color(0xFF9A9A9A),
                  ),
                ],
              ),
            ),
          ],
        ),
        // 문구를 RichText로 교체하여 '대표 반려동물'만 주황색으로 강조
        SizedBox(height: screenHeight * 0.01),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '반려동물 선택 시 ',
                style: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: const Color(0xFF9A9A9A)),
              ),
              TextSpan(
                text: '대표 반려동물',
                style: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: const Color(0xFFFF5F01),
                    fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: '로 설정됩니다.',
                style: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: const Color(0xFF9A9A9A)),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.025),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: pets
                .map((p) => Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.05),
                      child: _PetCard(
                        name: p.name,
                        isSelected: p.id == selectedPetId,
                        imageUrl: p.imageUrl,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _PetCard extends StatelessWidget {
  final String name;
  final bool isSelected;
  final String? imageUrl;

  const _PetCard({
    required this.name,
    required this.isSelected,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.19, // 아이콘 조금 더 크게
          height: screenWidth * 0.19,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5F01) : Colors.grey[300]!,
              width: screenWidth * 0.006,
            ),
            // boxShadow: [
            //   BoxShadow(
            //     // 빛나는 효과 조절: withOpacity 값으로 투명도 조절 (0.0 ~ 1.0)
            //     // 예: 0.3 = 더 연하게, 0.8 = 더 진하게
            //     color: const Color(0xFFFF5F01).withOpacity(0.6),
            //     // blurRadius: 블러 반경 조절 (값이 클수록 더 넓게 번짐)
            //     blurRadius: screenWidth * 0.02,
            //     // spreadRadius: 확산 반경 조절 (값이 클수록 더 크게 확산)
            //     spreadRadius: screenWidth * 0.001,
            //   ),
            // ],
          ),
          child: PetAvatar(
            imageUrl: imageUrl,
            size: screenWidth * 0.19,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.026,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF5C5C5C),
          ),
        ),
      ],
    );
  }
}

class PetListItem {
  final int id;
  final String name;
  final String? imageUrl;
  const PetListItem(
      {required this.id, required this.name, required this.imageUrl});
}
