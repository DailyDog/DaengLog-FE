import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/customs/draw_custom.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/customs/frame_custom.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/customs/sticker_custom.dart';
import 'package:daenglog_fe/features/chat_photo/models/photo_sticker_model.dart';

// --- 꾸미기 모드 위젯 ---
class ImageCustomWidget extends StatefulWidget {
  final VoidCallback onComplete; // 완료 버튼 클릭 시 호출
  final VoidCallback onDrawingMode; // 그리기 모드 활성화 시 호출
  final Color selectedColor; // 선택된 색상
  final bool isEraser; // 지우개 모드 활성화 여부
  final Function(Color) onColorChanged; // 색상 변경 시 호출
  final VoidCallback onEraserToggle; // 지우개 모드 토글 시 호출
  final Color selectedFrameColor; // 선택된 프레임 색상
  final Function(Color) onFrameColorChanged; // 프레임 색상 변경 시 호출
  final Function(Sticker) onStickerSelected; // 스티커 선택 시 호출

  const ImageCustomWidget({
    super.key,
    required this.onComplete, // 완료 버튼 클릭 시 호출
    required this.onDrawingMode, // 그리기 모드 활성화 시 호출
    required this.selectedColor, // 선택된 색상
    required this.isEraser, // 지우개 모드 활성화 여부
    required this.onColorChanged, // 색상 변경 시 호출
    required this.onEraserToggle, // 지우개 모드 토글 시 호출
    required this.selectedFrameColor, // 선택된 프레임 색상
    required this.onFrameColorChanged, // 프레임 색상 변경 시 호출
    required this.onStickerSelected, // 스티커 선택 시 호출
  });

  @override
  State<ImageCustomWidget> createState() => _ImageCustomWidgetState();
}

class _ImageCustomWidgetState extends State<ImageCustomWidget> {
  int selectedIndex = 0; // 선택된 탭 인덱스 (0: 프레임, 1: 스티커, 2: 그리기)

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 슬라이드 탭 메뉴 ---
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _buildTabItem('프레임', 0),
              ),
              Expanded(
                child: _buildTabItem('스티커', 1),
              ),
              Expanded(
                child: _buildTabItem('그리기', 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // --- 선택된 탭에 따른 내용 표시 ---
        _buildTabContent(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        // 그리기 탭 선택 시 그리기 모드 활성화
        if (index == 2) {
          widget.onDrawingMode();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFFFF6600) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? const Color(0xFFFF6600) : const Color(0xFF9E9E9E),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedIndex) {
      case 0: // 프레임
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 프레임 색상 선택 위젯
              FrameColorPickerWidget(
                selectedFrameColor: widget.selectedFrameColor,
                onFrameColorChanged: widget.onFrameColorChanged,
              ),
            ],
          ),
        );
      case 1: // 스티커
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 스티커 선택 위젯
              StickerPickerWidget(
                onStickerSelected: widget.onStickerSelected,
              ),
            ],
          ),
        );
      case 2: // 그리기
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '그리기 도구',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF272727),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '색상을 선택하고 그려보세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(height: 20),
              // 색상 선택 위젯
              ColorPickerWidget(
                selectedColor: widget.selectedColor,
                isEraser: widget.isEraser,
                onColorChanged: widget.onColorChanged,
                onEraserToggle: widget.onEraserToggle,
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}