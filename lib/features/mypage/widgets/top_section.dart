import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';

class MyPageTopSection extends StatelessWidget {
  final MyPageSummary? summary;
  final bool loading;
  final String? imageUrl; // pre-resolved image url from screen

  const MyPageTopSection({super.key, required this.summary, required this.loading, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(screenWidth * 0.1, screenHeight * 0.08, screenWidth * 0.1, 0),
      child: Row(
        children: [
          PetAvatar(imageUrl: imageUrl, size: screenWidth * 0.32),
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


