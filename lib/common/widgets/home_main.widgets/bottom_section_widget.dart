// 홈 화면 망고의 일주일 밑 부분 위젯

import 'package:flutter/material.dart';
import 'package:daenglog_fe/models/homeScreen/widget_item.dart';
import 'package:daenglog_fe/common/componenet/bottom_section_widget/widget_section_modal.dart';
import 'package:daenglog_fe/models/homeScreen/profile.dart';

class BottomSectionWidget extends StatefulWidget {
  const BottomSectionWidget({super.key, required this.profile});
  final Profile? profile;

  @override
  State<BottomSectionWidget> createState() => _BottomSectionWidgetState();
}

class _BottomSectionWidgetState extends State<BottomSectionWidget> {
  // 선택된 위젯들 (기본값: 공지사항, 캠퍼스맵, 학사일정)
  List<String> selectedWidgets = ['일기', '산책', '오늘의 미션', '날씨'];
  
  // 사용 가능한 모든 위젯들
  final List<WidgetItem> availableWidgets = [
    WidgetItem(id: '일기', title: '일기', description: '망고의 기분은 어떨까?', icon: Icons.library_books, color: Colors.indigo),
    WidgetItem(id: '산책', title: '산책', description: '이번주 망고는\n 얼마나 산책을 했나?', icon: Icons.restaurant, color: Colors.red),
    WidgetItem(id: '오늘의 미션', title: '오늘의 미션', description: '망고와 신나는 미션', icon: Icons.directions_bus, color: Colors.teal),
    WidgetItem(id: '날씨', title: '날씨', description: '성북구 정릉동', icon: Icons.wb_sunny, color: Colors.amber),
  ];

  // 위젯 선택 모달 표시
  void _showWidgetSelectionModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => WidgetSelectionModal(
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
                  WidgetItem(
                    id: 'add_widget',
                    title: '',
                    description: '',
                    icon: Icons.add,
                    color: Colors.orange,
                  ),
                  isSelectionCard: true,
                );
              } else {
                // 위젯 카드들
                final widgetId = selectedWidgets[index];
                final widget = availableWidgets.firstWhere((w) => w.id == widgetId);
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
  Widget _buildDraggableWidgetCard(WidgetItem widget, int index) {
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
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 24,
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
        child: const Center(
          child: Icon(
            Icons.drag_handle,
            color: Colors.grey,
            size: 32,
          ),
        ),
      ),
      child: DragTarget<String>(
        onWillAccept: (data) => data != widget.id,
        onAccept: (data) {
          final draggedIndex = selectedWidgets.indexOf(data);
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
  Widget _buildWidgetCard(WidgetItem widget, {bool isSelectionCard = false}) {
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
            child: Icon(
              widget.icon,
              color: widget.color,
              size: 32,
            ),
          ),
        ),
      );
    }
    // 일반 위젯 카드
    return Container(
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
                const Icon(
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
              child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
