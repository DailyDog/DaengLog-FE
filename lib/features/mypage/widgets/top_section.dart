import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';

class MyPageTopSection extends StatelessWidget {
  final MyPageSummary? summary;
  final bool loading;
  final String? imageUrl;
  final PetProfileProvider provider;

  const MyPageTopSection({
    super.key,
    required this.summary,
    required this.loading,
    required this.imageUrl,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 반응형 크기 계산
    final avatarSize = (screenWidth * 0.7).clamp(100.0, 130.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.1, screenHeight * 0,
          screenWidth * 0.01, 35), // 우측으로 이동, 위로 올림
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 아바타 영역
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: PetAvatar(
              imageUrl: imageUrl,
              size: avatarSize,
              borderWidth: 4,
              borderColor: const Color(0xFFFFC29E),
              petId: provider.defaultPet?.id ?? summary?.defaultPet.id,
            ),
          ),

          SizedBox(width: screenWidth * 0.1),

          // 텍스트 영역
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loading ? '...' : _getGreetingText(provider),
                  style: TextStyle(
                    fontSize: screenWidth * 0.064,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.016),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.007,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.018),
                  ),
                  child: Text(
                    _getPlanText(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.029,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFFF5F01),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreetingText(PetProfileProvider provider) {
    if (provider.allPets.isEmpty) {
      return '${summary?.userName ?? ''}님,\n안녕하세요!';
    } else {
      return '${summary?.defaultPet.name ?? ''} 집사님,\n안녕하세요!';
    }
  }

  String _getPlanText() {
    if (summary?.planName == null || summary!.planName.isEmpty) {
      return '개인 플랜';
    }
    return '${summary!.planName} 플랜';
  }
}
