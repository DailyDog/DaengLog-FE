import 'package:flutter/material.dart';
import '../providers/photo_screen_provider.dart';

// 데코레이트 도구 열거형
enum DecorationTool {
  frame,
  draw,
  sticker,
}

// 데코레이트 도구 위젯
class DecorationToolsWidget extends StatelessWidget {
  final DecorationTool selectedTool;
  final Function(DecorationTool) onToolSelected;
  final PhotoScreenProvider provider;

  const DecorationToolsWidget({
    super.key,
    required this.provider,
    required this.selectedTool,
    required this.onToolSelected
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageHeight = size.height * 0.45;
    final toolHeight = imageHeight * 0.8; 

    return Container(
      width: double.infinity,
      height: imageHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 구분선
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFB7B7B7),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolButton(
                  tool: DecorationTool.frame,
                  label: '프레임',
                ),
                _buildToolButton(
                  tool: DecorationTool.draw,
                  label: '그리기',
                ),
                _buildToolButton(
                  tool: DecorationTool.sticker,
                  label: '스티커',
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: toolHeight,
            child: _buildToolOptions(provider),
          ),
        ],
      ),
    );
  }

  // 도구 버튼
  Widget _buildToolButton({
    required DecorationTool tool,
    required String label,
  }) {
    final isSelected = selectedTool == tool;
    
    return GestureDetector(
      onTap: () => onToolSelected(tool),
      child: Container(
        width: 50,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 1),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Pretendard-Medium',
                fontSize: 12,
                color: isSelected ? const Color(0xFFF56F01) : const Color(0xFFB7B7B7),
              ),
              
            ),
            const SizedBox(height: 4), // 텍스트와 밑줄 간격
            Container(
              height: 2,
              width: 50, // 원하는 길이
              color: isSelected ? Color(0xFFF56F01) :  Colors.white, // 밑줄 색상
            ),
          ],
        ),
      ),
    );
  }

  // 도구 옵션
  Widget _buildToolOptions(PhotoScreenProvider provider) {
    switch (selectedTool) {
      case DecorationTool.frame:
        return _buildFrameOptions(provider);
      case DecorationTool.draw:
        return _buildDrawOptions(provider);
      case DecorationTool.sticker:
        return _buildStickerOptions(provider);
    }
  }

  // 프레임 옵션
  Widget _buildFrameOptions(PhotoScreenProvider provider) {
    final frameColors = [
      const Color(0xFFFF6600),
      const Color(0xFF000000),
      const Color(0xFFFFFFFF),
      const Color(0xFF00FF00),
      const Color(0xFF0000FF),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            children: frameColors.map((color) {
              return GestureDetector(
                onTap: () {
                  provider.setImageAndContentColor(color);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 그림 그리기 옵션
  Widget _buildDrawOptions(PhotoScreenProvider provider) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap( // 자식 위젯들을 가로 또는 세로로 감싸서 배치하다 공간 부족시 다음 줄로 넘기는 레이아웃 위젲
            spacing: 8,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  provider.setSelectedColor(color);
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Slider(
            value: provider.strokeWidth,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            onChanged: (value) {
              provider.setStrokeWidth(value);
            },
            activeColor: const Color(0xFFF56F01),
          ),
        ],
      ),
    );
  }

  // 스티커 옵션
  Widget _buildStickerOptions(PhotoScreenProvider provider) {
    final stickers = [
      Icons.favorite,
      Icons.star,
      Icons.pets,
      Icons.emoji_emotions,
      Icons.cake,
      Icons.local_florist,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '스티커',
            style: TextStyle(
              fontFamily: 'Pretendard-Medium',
              fontSize: 12,
              color: Color(0xFF272727),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: stickers.map((icon) {
              return GestureDetector(
                onTap: () {
                  // 스티커 추가 로직
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF272727),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
