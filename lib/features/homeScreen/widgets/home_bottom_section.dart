// 홈 화면 망고의 일주일 밑 부분 위젯

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/homeScreen/models/home_widget_item.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/components/home_bottom_section_modal.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/features/weather/providers/weather_provider.dart';
import 'package:provider/provider.dart';

class HomeBottomSection extends StatefulWidget {
  const HomeBottomSection({super.key});

  @override
  State<HomeBottomSection> createState() => _HomeBottomSectionState();
}

class _HomeBottomSectionState extends State<HomeBottomSection> {
  // 선택된 위젯들 (기본값: 공지사항, 캠퍼스맵, 학사일정)
  List<String> selectedWidgets = ['일기', '산책', '오늘의 미션', '날씨'];

  // 사용 가능한 모든 위젯들
  final List<HomeWidgetItem> availableWidgets = [
    HomeWidgetItem(
        id: '일기',
        title: '일기',
        description: '망고의 기분은 어떨까?',
        iconPath: 'assets/images/home/widget/Journal_icon.png'),
    HomeWidgetItem(
        id: '산책',
        title: '산책',
        description: '이번주 망고는\n얼마나 산책을 했나?',
        iconPath: 'assets/images/home/widget/dog_icon.png'),
    HomeWidgetItem(
        id: '오늘의 미션',
        title: '오늘의 미션',
        description: '망고와 신나는 미션',
        iconPath: 'assets/images/home/widget/Goal_icon.png'),
    HomeWidgetItem(
        id: '날씨',
        title: '날씨',
        description: '성북구 정릉동',
        iconPath: 'assets/images/home/widget/Sun_icon.png'),
  ];

  // 위젯 선택 모달 표시
  void _showWidgetSelectionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => HomeBottomSectionModal(
        availableWidgets: availableWidgets,
        selectedWidgets: selectedWidgets,
        onSelectionChanged: (newSelection) {
          setState(() {
            selectedWidgets = newSelection;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.read<DefaultProfileProvider>().profile;
    final weatherProvider = context.watch<WeatherProvider>();

    // 날씨 위젯의 위치 정보 업데이트
    final weatherWidget = availableWidgets.firstWhere((w) => w.id == '날씨');
    final displayLocation = weatherProvider.weather?.location ?? '성북구 정릉동';

    return Container(
      color: const Color(0XFFF9F9F9),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 선택된 위젯들과 위젯 선택 버튼을 함께 표시
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2개씩 표시
              crossAxisSpacing: 12, // 가로 간격
              mainAxisSpacing: 12, // 세로 간격
              childAspectRatio: 1, // 위젯 비율
            ),
            itemCount: selectedWidgets.length + 1, // 위젯 개수 + 선택 버튼 1개
            itemBuilder: (context, index) {
              if (index == selectedWidgets.length) {
                // 마지막 아이템은 위젯 선택 버튼
                return _buildWidgetCard(
                  HomeWidgetItem(
                    id: 'add_widget',
                    title: '',
                    description: '',
                    iconPath: 'assets/images/home/widget/plus_icon.png',
                  ),
                  isSelectionCard: true,
                );
              } else {
                // 위젯 카드들
                final widgetId = selectedWidgets[index];
                final widget =
                    availableWidgets.firstWhere((w) => w.id == widgetId);

                // 날씨 위젯인 경우 동적 위치 정보 사용
                if (widgetId == '날씨') {
                  final dynamicWidget = HomeWidgetItem(
                    id: widget.id,
                    title: widget.title,
                    description: displayLocation,
                    iconPath: widget.iconPath,
                  );
                  return _buildDraggableWidgetCard(dynamicWidget, index);
                }

                return _buildDraggableWidgetCard(widget, index);
              }
            },
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------
  // 드래그 가능한 위젯 카드 생성
  Widget _buildDraggableWidgetCard(HomeWidgetItem widget, int index) {
    return Draggable<String>(
      data: widget.id,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                ),
                const SizedBox(height: 8), // 위젯 간격
                Expanded(
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2, // 최대 2줄까지 표시
                    overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                  ),
                ),
                const SizedBox(height: 8), // 위젯 간격
                Align(
                  alignment: Alignment.bottomRight, // 아이콘 위치
                  child: Image.asset(
                    widget.iconPath!,
                    width: 44,
                    height: 44,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
        ),
        child: Center(
          child: Icon(
            Icons.drag_indicator,
            color: Colors.grey,
            size: 32,
          ),
        ),
      ),
      child: DragTarget<String>(
        onWillAcceptWithDetails: (details) => details.data != widget.id,
        onAcceptWithDetails: (details) {
          final draggedIndex = selectedWidgets.indexOf(details.data);
          if (draggedIndex != -1) {
            setState(() {
              final draggedItem = selectedWidgets.removeAt(draggedIndex);
              selectedWidgets.insert(index, draggedItem);
            });
          }
        },
        builder: (context, candidateData, rejectedData) {
          return _buildWidgetCard(widget);
        },
      ),
    );
  }

//------------------------------------------------------------
  // 위젯 카드 생성
  Widget _buildWidgetCard(HomeWidgetItem widget,
      {bool isSelectionCard = false}) {
    if (isSelectionCard) {
      // 위젯 선택 버튼 - 아이콘을 정가운데에 배치
      return GestureDetector(
        onTap: () => _showWidgetSelectionModal(context),
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
          child: Center(
            child: Image.asset(
              widget.iconPath!,
              width: 40,
              height: 40,
            ),
          ),
        ),
      );
    }
    // 일반 위젯 카드
    return GestureDetector(
      onTap: () {
        // 날씨 위젯 클릭 시 날씨 화면으로 이동
        if (widget.id == '날씨') {
          context.push('/weather');
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
