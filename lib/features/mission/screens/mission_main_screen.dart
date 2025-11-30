import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/mission_app_bar.dart';
import '../widgets/mission_profile_section.dart';
import '../widgets/mission_coin_rewards.dart';
import '../widgets/mission_card_list.dart';

/// 미션 메인 화면
/// 
/// 사용자가 수행할 수 있는 미션들을 보여주는 화면입니다.
/// - 반려동물 프로필 이미지
/// - 미션 완료 시 코인 적립 안내
/// - 코인 보상 표시 (100C, 300C, 500C)
/// - 미션 카드 리스트
/// 
/// Figma 디자인: 2-2-3 미션 화면
class MissionMainScreen extends StatelessWidget {
  const MissionMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 앱바: 뒤로가기, 제목, 코인 표시
      appBar: MissionAppBar(
        onBack: () {
          // 뒤로가기
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 프로필 섹션 (반려동물 이미지 + 안내 텍스트)
            const MissionProfileSection(),
            
            const SizedBox(height: 30),
            
            // 코인 보상 표시 (100C, 300C, 500C)
            const MissionCoinRewards(),
            
            const SizedBox(height: 30),
            
            // 미션 카드 리스트
            const MissionCardList(),
            
            // 하단 여백
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

