// 홈 화면 망고의 일주일 밑 부분 위젯

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/homeScreen/models/home_widget_item.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/features/weather/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class HomeBottomSection extends StatefulWidget {
  const HomeBottomSection({super.key});

  @override
  State<HomeBottomSection> createState() => _HomeBottomSectionState();
}

class _HomeBottomSectionState extends State<HomeBottomSection> {
  // 고정 위젯들
  final List<String> selectedWidgets = ['일기', '산책', '오늘의 미션', '날씨'];

  // 사용 가능한 모든 위젯들 (동적으로 생성)
  List<HomeWidgetItem> _getAvailableWidgets(String petName, String location) {
    return [
      HomeWidgetItem(
          id: '일기',
          title: '일기',
          description: '$petName의 기분은 어떨까?',
          iconPath: 'assets/images/home/widget/Journal_icon.png'),
      HomeWidgetItem(
          id: '산책',
          title: '산책',
          description: '이번주 $petName는\n얼마나 산책을 했나?',
          iconPath: 'assets/images/home/widget/dog_icon.png'),
      HomeWidgetItem(
          id: '오늘의 미션',
          title: '오늘의 미션',
          description: '$petName와 신나는 미션',
          iconPath: 'assets/images/home/widget/Goal_icon.png'),
      HomeWidgetItem(
          id: '날씨',
          title: '날씨',
          description: location,
          iconPath: 'assets/images/home/widget/Sun_icon.png'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<DefaultProfileProvider>().profile;
    final weatherProvider = context.watch<WeatherProvider>();

    // 반려동물 이름
    final petName = profile?.petName ?? '망고';

    // 날씨 위젯의 위치 정보 업데이트
    final displayLocation = weatherProvider.weather?.location ?? '성북구 정릉동';

    // 동적으로 위젯 리스트 생성
    final availableWidgets = _getAvailableWidgets(petName, displayLocation);

    return Container(
      color: const Color(0XFFF9F9F9),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 선택된 위젯들만 표시 (4개)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2개씩 표시
              crossAxisSpacing: 12, // 가로 간격
              mainAxisSpacing: 12, // 세로 간격
              childAspectRatio: 1, // 위젯 비율
            ),
            itemCount: selectedWidgets.length, // 위젯 4개만 표시
            itemBuilder: (context, index) {
              // 위젯 카드들
              final widgetId = selectedWidgets[index];
              final widget =
                  availableWidgets.firstWhere((w) => w.id == widgetId);

              return _buildDraggableWidgetCard(widget, index);
            },
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------
  // (드래그 제거) 일반 위젯 카드만 사용
  Widget _buildDraggableWidgetCard(HomeWidgetItem widget, int index) {
    return _buildWidgetCard(widget);
  }

//------------------------------------------------------------
  // 위젯 카드 생성
  Widget _buildWidgetCard(HomeWidgetItem widget,
      {bool isSelectionCard = false, List<HomeWidgetItem>? availableWidgets}) {
    if (isSelectionCard) {
      // 현재 선택 카드 기능 사용 안 함
      return const SizedBox.shrink();
    }
    // 일반 위젯 카드
    return GestureDetector(
      onTap: () {
        // 날씨 위젯 클릭 시 날씨 화면으로 이동
        if (widget.id == '날씨') {
          context.push('/weather');
        }
        // 일기 위젯 클릭 시 기록 화면으로 이동
        if (widget.id == '일기') {
          context.go('/record');
        }
        // 다른 위젯들도 필요에 따라 추가 가능
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 화살표
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 설명
              Expanded(
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // 아이콘
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  widget.iconPath!,
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
