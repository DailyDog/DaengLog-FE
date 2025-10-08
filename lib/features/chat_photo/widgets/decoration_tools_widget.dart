import 'package:flutter/material.dart';
import '../providers/photo_screen_provider.dart';
import '../models/photo_sticker_model.dart';

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
      Colors.black,
      Colors.white,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '색상 선택',
                style: TextStyle(
                  fontFamily: 'Pretendard-Medium',
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
              ),
              const Spacer(),
              if (provider.drawingPaths.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    provider.undoLastPath();
                  },
                  icon: const Icon(Icons.undo, size: 16, color: Color(0xFFFF6600)),
                  label: const Text(
                    '실행 취소',
                    style: TextStyle(
                      fontFamily: 'Pretendard-Medium',
                      fontSize: 11,
                      color: Color(0xFFFF6600),
                    ),
                  ),
                ),
              if (provider.drawingPaths.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    provider.clearDrawing();
                  },
                  icon: const Icon(Icons.clear, size: 16, color: Color(0xFFFF6600)),
                  label: const Text(
                    '전체 삭제',
                    style: TextStyle(
                      fontFamily: 'Pretendard-Medium',
                      fontSize: 11,
                      color: Color(0xFFFF6600),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: colors.map((color) {
              final isSelected = provider.selectedColor == color;
              return GestureDetector(
                onTap: () {
                  provider.setSelectedColor(color);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF6600) : Colors.grey.shade300,
                      width: isSelected ? 3 : 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                '굵기',
                style: TextStyle(
                  fontFamily: 'Pretendard-Medium',
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: provider.strokeWidth,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  label: provider.strokeWidth.toStringAsFixed(0),
                  onChanged: (value) {
                    provider.setStrokeWidth(value);
                  },
                  activeColor: const Color(0xFFF56F01),
                ),
              ),
              Text(
                provider.strokeWidth.toStringAsFixed(0),
                style: const TextStyle(
                  fontFamily: 'Pretendard-Medium',
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 스티커 옵션
  Widget _buildStickerOptions(PhotoScreenProvider provider) {
    final stickers = [
      Sticker(id: 'heart', icon: Icons.favorite, name: '하트', category: 'emotion'),
      Sticker(id: 'star', icon: Icons.star, name: '별', category: 'shape'),
      Sticker(id: 'pets', icon: Icons.pets, name: '발바닥', category: 'animal'),
      Sticker(id: 'smile', icon: Icons.emoji_emotions, name: '웃는 얼굴', category: 'emotion'),
      Sticker(id: 'cake', icon: Icons.cake, name: '케이크', category: 'food'),
      Sticker(id: 'flower', icon: Icons.local_florist, name: '꽃', category: 'nature'),
      Sticker(id: 'sun', icon: Icons.wb_sunny, name: '해', category: 'weather'),
      Sticker(id: 'cloud', icon: Icons.cloud, name: '구름', category: 'weather'),
      Sticker(id: 'music', icon: Icons.music_note, name: '음표', category: 'music'),
      Sticker(id: 'gift', icon: Icons.card_giftcard, name: '선물', category: 'object'),
      Sticker(id: 'camera', icon: Icons.camera_alt, name: '카메라', category: 'object'),
      Sticker(id: 'thumb_up', icon: Icons.thumb_up, name: '좋아요', category: 'gesture'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '스티커를 선택한 후 이미지를 터치하세요',
                style: TextStyle(
                  fontFamily: 'Pretendard-Medium',
                  fontSize: 11,
                  color: Color(0xFF666666),
                ),
              ),
              if (provider.placedStickers.isNotEmpty)
                TextButton(
                  onPressed: () {
                    if (provider.selectedStickerIndex != null) {
                      provider.removeSticker(provider.selectedStickerIndex!);
                    }
                  },
                  child: const Text(
                    '선택 삭제',
                    style: TextStyle(
                      fontFamily: 'Pretendard-Medium',
                      fontSize: 11,
                      color: Color(0xFFFF6600),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 120,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: stickers.length,
              itemBuilder: (context, index) {
                final sticker = stickers[index];
                final isSelected = provider.selectedSticker?.id == sticker.id;
                
                return GestureDetector(
                  onTap: () {
                    provider.selectSticker(sticker);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF3E0) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? const Color(0xFFFF6600) : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Icon(
                      sticker.icon,
                      size: 24,
                      color: isSelected ? const Color(0xFFFF6600) : const Color(0xFF272727),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
