import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_horizontal_list.dart';
import 'package:daenglog_fe/features/mypage/widgets/section_divider.dart';
import 'package:daenglog_fe/features/mypage/widgets/menu_item.dart';

class MyPageBottomSection extends StatelessWidget {
  final List<PetListItem> pets;
  final int? selectedPetId;
  final VoidCallback onEditPets;

  const MyPageBottomSection({
    super.key,
    required this.pets,
    required this.selectedPetId,
    required this.onEditPets,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.1, screenHeight * 0.05, screenWidth * 0.1, screenHeight * 0.12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PetHorizontalList(
            pets: pets,
            selectedPetId: selectedPetId,
            onEditTap: onEditPets,
          ),

          SizedBox(height: screenHeight * 0.02),
          const SectionDivider(),
          SizedBox(height: screenHeight * 0.02),

          SizedBox(height: screenHeight * 0.01),

          MyPageMenuItem(title: '내정보 관리', icon: Icons.person_outline, onTap: () => Navigator.pushNamed(context, '/my_info_page')),
          MyPageMenuItem(title: '이벤트/혜택', icon: Icons.card_giftcard, onTap: () => Navigator.pushNamed(context, '/event')),
          MyPageMenuItem(title: '요금제 관리', icon: Icons.payment, onTap: () => Navigator.pushNamed(context, '/cloud_main')),
          MyPageMenuItem(title: '공지사항', icon: Icons.announcement, onTap: () => Navigator.pushNamed(context, '/notice')),
          MyPageMenuItem(title: '고객센터', icon: Icons.help_outline, onTap: () => Navigator.pushNamed(context, '/customer_center')),

          SizedBox(height: screenHeight * 0.02),
          const SectionDivider(),
          SizedBox(height: screenHeight * 0.02),

          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD4B0),
                borderRadius: BorderRadius.circular(screenWidth * 0.15),
              ),
              child: Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.006),
          Center(
            child: Text(
              'Ver 1.01',
              style: TextStyle(
                fontSize: screenWidth * 0.025,
                color: const Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


