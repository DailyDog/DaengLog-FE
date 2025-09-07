import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';
import 'package:daenglog_fe/shared/utils/image_utils.dart';

class MyPageTopSection extends StatelessWidget {
  final MyPageSummary? summary;
  final bool loading;

  const MyPageTopSection({super.key, required this.summary, required this.loading});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final summaryUrl = ImageUtils.sanitizePresignedUrl(summary?.defaultPet.profileImageUrl);

    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.1, screenHeight * 0.08, screenWidth * 0.1, 0),
      child: Row(
        children: [
          Consumer<DefaultProfileProvider>(
            builder: (context, defaultProfile, _) {
              final providerUrl = defaultProfile.imagePath;
              // 홈과 동일하게 Provider 우선 → 실패 시 요약 URL 사용
              final displayUrl = (providerUrl != null && providerUrl.isNotEmpty)
                  ? providerUrl
                  : ((summaryUrl != null && summaryUrl.isNotEmpty) ? summaryUrl : null);
              return PetAvatar(
                imageUrl: displayUrl,
                size: screenWidth * 0.32,
              );
            },
          ),
          SizedBox(width: screenWidth * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loading ? '...' : '${summary?.defaultPet.name ?? ''} 집사님,\n안녕하세요!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
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
                    '${summary?.planName ?? ''} 플랜',
                    style: TextStyle(
                      fontSize: screenWidth * 0.029,
                      fontWeight: FontWeight.w600,
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
}


