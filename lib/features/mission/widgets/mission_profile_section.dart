import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../record/providers/record_provider.dart';

/// 미션 프로필 섹션 위젯
/// 
/// 반려동물 프로필 이미지와 안내 텍스트를 표시합니다.
/// Figma 디자인: 2-2-3 미션 화면 (프로필 섹션)
class MissionProfileSection extends StatelessWidget {
  const MissionProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordProvider>(
      builder: (context, recordProvider, child) {
        final selectedPet = recordProvider.selectedPet;
        
        return Column(
          children: [
            const SizedBox(height: 20),
            // 반려동물 프로필 이미지 (원형, 주황색 테두리)
            Container(
              width: 126,
              height: 126,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF5F01),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: selectedPet?.profileImageUrl != null
                    ? Image.network(
                        selectedPet!.profileImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder();
                        },
                      )
                    : _buildPlaceholder(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 안내 텍스트
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '미션을 완료하면\n'),
                  TextSpan(
                    text: '코인',
                    style: TextStyle(
                      color: Color(0xFFFF5F01),
                    ),
                  ),
                  TextSpan(text: '을 적립해 드려요'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// 프로필 이미지가 없을 때 플레이스홀더
  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 60,
          color: Color(0xFFCCCCCC),
        ),
      ),
    );
  }
}

