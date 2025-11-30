import 'package:flutter/material.dart';

/// 미션 코인 보상 위젯
/// 
/// 미션 완료 시 받을 수 있는 코인 보상을 표시합니다.
/// 100C, 300C, 500C 세 가지 보상이 있습니다.
/// 
/// Figma 디자인: 2-2-3 미션 화면 (코인 보상)
class MissionCoinRewards extends StatelessWidget {
  const MissionCoinRewards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 272,
      height: 104,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFADADAD),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 100C 보상 (선택됨 - 주황색)
          _buildCoinReward(
            coin: 100,
            isSelected: true,
          ),
          // 300C 보상
          _buildCoinReward(
            coin: 300,
            isSelected: false,
          ),
          // 500C 보상
          _buildCoinReward(
            coin: 500,
            isSelected: false,
          ),
        ],
      ),
    );
  }

  /// 개별 코인 보상 아이템 위젯
  Widget _buildCoinReward({
    required int coin,
    required bool isSelected,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 코인 아이콘 (원형)
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected
                ? const Color(0xFFFF5F01) // 선택됨: 주황색
                : const Color(0xFFF5F5F5), // 미선택: 회색
            border: isSelected
                ? null
                : Border.all(
                    color: const Color(0xFFE0E0E0),
                    width: 1,
                  ),
          ),
          child: Icon(
            Icons.pets, // TODO: 실제 코인 아이콘으로 교체
            size: 24,
            color: isSelected ? Colors.white : const Color(0xFFCCCCCC),
          ),
        ),
        const SizedBox(height: 8),
        // 코인 수 텍스트
        Text(
          '${coin}C',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? const Color(0xFFFF5F01) // 선택됨: 주황색
                : const Color(0xFFADADAD), // 미선택: 회색
          ),
        ),
      ],
    );
  }
}

