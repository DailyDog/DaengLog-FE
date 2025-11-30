import 'package:flutter/material.dart';
import '../models/mission_item.dart';

/// 미션 카드 리스트 위젯
/// 
/// 모든 미션 카드를 그리드 형태로 표시합니다.
/// Figma 디자인: 2-2-3 미션 화면 (미션 카드 리스트)
class MissionCardList extends StatelessWidget {
  const MissionCardList({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: API 연결 시 실제 데이터로 교체
    // 임시 더미 데이터
    final missions = _generateDummyMissions();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2열 그리드
          crossAxisSpacing: 16, // 가로 간격 (Figma: 약 16px)
          mainAxisSpacing: 20, // 세로 간격
          childAspectRatio: 0.77, // 카드 비율 (136px / 176px)
        ),
        itemCount: missions.length,
        itemBuilder: (context, index) {
          final mission = missions[index];
          return MissionCard(
            mission: mission,
            onTap: () {
              // TODO: 미션 수행 화면으로 이동
              // context.push('/mission-detail/${mission.id}');
            },
          );
        },
      ),
    );
  }

  /// 임시 더미 미션 데이터 생성
  /// 
  /// TODO: API 연결 시 제거 필요
  /// API: GET /api/v1/missions
  List<MissionItem> _generateDummyMissions() {
    return [
      MissionItem(
        id: 1,
        title: '기분 알아보기',
        description: '사진찍고 망고의\n오늘 기분 알아보기',
        coinReward: 100,
        type: 'mood',
        isCompleted: false,
      ),
      MissionItem(
        id: 2,
        title: '산책',
        description: '망고와 산책 나가서\n나무 앞에서 함께 셀카찍기',
        coinReward: 300,
        type: 'walk',
        isCompleted: false,
      ),
      MissionItem(
        id: 3,
        title: '가족 공유',
        description: '망고의 사진과 일기를\n가족 구성원에게 공유',
        coinReward: 500,
        type: 'family_share',
        isCompleted: false,
      ),
      MissionItem(
        id: 4,
        title: '가족 공유',
        description: '망고의 사진과 일기를\n가족 구성원에게 공유',
        coinReward: 500,
        type: 'family_share',
        isCompleted: false,
      ),
    ];
  }
}

/// 개별 미션 카드 위젯
/// 
/// 하나의 미션 정보를 카드 형태로 표시합니다.
class MissionCard extends StatelessWidget {
  final MissionItem mission;
  final VoidCallback onTap;

  const MissionCard({
    super.key,
    required this.mission,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 176,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFFF5F01),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: mission.isCompleted
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 상단: 아이콘 + 제목 + 설명
              Expanded(
                child: Column(
                  children: [
                    // 미션 아이콘
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFF5F01).withOpacity(0.1),
                      ),
                      child: _buildMissionIcon(mission.type),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // 미션 제목
                    Text(
                      mission.title,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5C5C5C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 미션 설명
                    Text(
                      mission.description,
                      style: const TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFADADAD),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // 하단: 미션 수행하기 버튼
              Container(
                width: double.infinity,
                height: 19,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5F01),
                  borderRadius: BorderRadius.circular(4.4),
                ),
                child: const Center(
                  child: Text(
                    '미션 수행하기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 미션 타입에 따라 아이콘 반환
  Widget _buildMissionIcon(String type) {
    IconData iconData;
    
    switch (type) {
      case 'mood':
        iconData = Icons.sentiment_satisfied_alt; // 기분 아이콘
        break;
      case 'walk':
        iconData = Icons.directions_walk; // 산책 아이콘
        break;
      case 'family_share':
        iconData = Icons.family_restroom; // 가족 공유 아이콘
        break;
      default:
        iconData = Icons.task_alt; // 기본 아이콘
    }
    
    return Icon(
      iconData,
      size: 24,
      color: const Color(0xFFFF5F01),
    );
  }
}

