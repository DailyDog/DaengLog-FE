import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/chat_photo/models/photo_sticker_model.dart';


// --- 스티커 선택 위젯 ---
class StickerPickerWidget extends StatefulWidget {
  final Function(Sticker) onStickerSelected;

  const StickerPickerWidget({
    super.key,
    required this.onStickerSelected,
  });

  @override
  State<StickerPickerWidget> createState() => _StickerPickerWidgetState();
}

class _StickerPickerWidgetState extends State<StickerPickerWidget> {
  String selectedCategory = 'emoji';
  
  // 스티커 데이터
  final List<Sticker> stickers = [
    // 이모지 카테고리
    Sticker(id: 'heart', icon: Icons.favorite, name: '하트', category: 'emoji'),
    Sticker(id: 'star', icon: Icons.star, name: '별', category: 'emoji'),
    Sticker(id: 'fire', icon: Icons.local_fire_department, name: '불', category: 'emoji'),
    Sticker(id: 'thumbs_up', icon: Icons.thumb_up, name: '좋아요', category: 'emoji'),
    Sticker(id: 'smile', icon: Icons.sentiment_satisfied, name: '웃음', category: 'emoji'),
    Sticker(id: 'sad', icon: Icons.sentiment_dissatisfied, name: '슬픔', category: 'emoji'),
    Sticker(id: 'love', icon: Icons.favorite_border, name: '사랑', category: 'emoji'),
    Sticker(id: 'cool', icon: Icons.sentiment_neutral, name: '쿨', category: 'emoji'),
    
    // 동물 카테고리
    Sticker(id: 'dog', icon: Icons.pets, name: '강아지', category: 'animal'),
    Sticker(id: 'cat', icon: Icons.pets, name: '고양이', category: 'animal'),
    Sticker(id: 'bird', icon: Icons.flutter_dash, name: '새', category: 'animal'),
    Sticker(id: 'fish', icon: Icons.water_drop, name: '물고기', category: 'animal'),
    Sticker(id: 'rabbit', icon: Icons.pets, name: '토끼', category: 'animal'),
    Sticker(id: 'bear', icon: Icons.pets, name: '곰', category: 'animal'),
    
    // 음식 카테고리
    Sticker(id: 'pizza', icon: Icons.local_pizza, name: '피자', category: 'food'),
    Sticker(id: 'cake', icon: Icons.cake, name: '케이크', category: 'food'),
    Sticker(id: 'coffee', icon: Icons.coffee, name: '커피', category: 'food'),
    Sticker(id: 'ice_cream', icon: Icons.icecream, name: '아이스크림', category: 'food'),
    Sticker(id: 'burger', icon: Icons.fastfood, name: '햄버거', category: 'food'),
    Sticker(id: 'apple', icon: Icons.apple, name: '사과', category: 'food'),
    
    // 활동 카테고리
    Sticker(id: 'sports', icon: Icons.sports_soccer, name: '축구', category: 'activity'),
    Sticker(id: 'music', icon: Icons.music_note, name: '음악', category: 'activity'),
    Sticker(id: 'game', icon: Icons.sports_esports, name: '게임', category: 'activity'),
    Sticker(id: 'book', icon: Icons.book, name: '책', category: 'activity'),
    Sticker(id: 'camera', icon: Icons.camera_alt, name: '카메라', category: 'activity'),
    Sticker(id: 'travel', icon: Icons.flight, name: '여행', category: 'activity'),
    
    // 자연 카테고리
    Sticker(id: 'flower', icon: Icons.local_florist, name: '꽃', category: 'nature'),
    Sticker(id: 'tree', icon: Icons.park, name: '나무', category: 'nature'),
    Sticker(id: 'sun', icon: Icons.wb_sunny, name: '태양', category: 'nature'),
    Sticker(id: 'moon', icon: Icons.nightlight_round, name: '달', category: 'nature'),
    Sticker(id: 'rain', icon: Icons.grain, name: '비', category: 'nature'),
    Sticker(id: 'snow', icon: Icons.ac_unit, name: '눈', category: 'nature'),
  ];

  final List<Map<String, dynamic>> categories = [
    {'id': 'emoji', 'name': '이모지', 'icon': Icons.emoji_emotions},
    {'id': 'animal', 'name': '동물', 'icon': Icons.pets},
    {'id': 'food', 'name': '음식', 'icon': Icons.restaurant},
    {'id': 'activity', 'name': '활동', 'icon': Icons.sports_soccer},
    {'id': 'nature', 'name': '자연', 'icon': Icons.nature},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStickers = stickers.where((sticker) => sticker.category == selectedCategory).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 선택
          const Text(
            '스티커 카테고리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF272727),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category['id'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category['id'];
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFF6600) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'],
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // 스티커 그리드
          const Text(
            '스티커 선택',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF272727),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: filteredStickers.length,
            itemBuilder: (context, index) {
              final sticker = filteredStickers[index];
              
              return GestureDetector(
                onTap: () {
                  widget.onStickerSelected(sticker);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        sticker.icon,
                        size: 24,
                        color: const Color(0xFF272727),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sticker.name,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
