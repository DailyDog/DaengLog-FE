import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_horizontal_list.dart';
import 'package:daenglog_fe/features/mypage/widgets/section_divider.dart';
import 'package:daenglog_fe/features/mypage/widgets/menu_item.dart';
import 'package:daenglog_fe/shared/services/logout_service.dart';

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

    // 상단 여백을 줄여 전체 섹션을 위로 올림
    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.1, screenHeight * 0.025,
          screenWidth * 0.1, screenHeight * 0.12),
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

          MyPageMenuItem(
              title: '내정보 관리',
              icon: Icons.person_outline,
              onTap: () => context.push('/my_info')),
          MyPageMenuItem(
              title: '이벤트/혜택',
              icon: Icons.card_giftcard,
              onTap: () => context.push('/event')),
          MyPageMenuItem(
              title: '요금제 관리',
              icon: Icons.payment,
              onTap: () => context.push('/cloud')),
          MyPageMenuItem(
              title: '공지사항',
              icon: Icons.announcement,
              onTap: () => context.push('/notice')),
          MyPageMenuItem(
              title: '고객센터',
              icon: Icons.help_outline,
              onTap: () => context.push('/customer_center')),

          SizedBox(height: screenHeight * 0.02),
          const SectionDivider(),
          SizedBox(height: screenHeight * 0.02),

          // 로그아웃 버튼 (모달의 스타일을 이곳으로 적용 + 얇은 주황 스트로크)
          GestureDetector(
            onTap: () => LogoutService.showLogoutDialog(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.018,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4D6),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x14FF5F01),
                      blurRadius: 18,
                      offset: Offset(0, 6)),
                ],
                border: Border.all(color: const Color(0xFFFFB98A), width: 1),
              ),
              child: Center(
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFFF5F01),
                  ),
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
