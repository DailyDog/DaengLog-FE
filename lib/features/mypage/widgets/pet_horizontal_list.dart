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
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
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
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9A9A9A),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  Transform.rotate(
                    angle: 270 * 3.14159 / 180,
                    child: Icon(
                      Icons.chevron_right,
                      size: screenWidth * 0.04,
                      color: const Color(0xFF9A9A9A),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          '반려동물 선택 시 대표 반려동물로 설정됩니다.',
          style: TextStyle(
            fontSize: screenWidth * 0.035,
            color: const Color(0xFF9A9A9A),
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
          width: screenWidth * 0.15,
          height: screenWidth * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5F01) : Colors.grey[400]!,
              width: screenWidth * 0.005,
            ),
          ),
          child: PetAvatar(
            imageUrl: imageUrl,
            size: screenWidth * 0.15,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.023,
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
  const PetListItem({required this.id, required this.name, required this.imageUrl});
}


