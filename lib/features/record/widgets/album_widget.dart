import 'package:flutter/material.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Album title
        Padding(
          padding: const EdgeInsets.only(left: 27, bottom: 16),
          child: Text(
            '앨범',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF272727),
            ),
          ),
        ),
        
        // Photo grid
        Container(
          height: 112,
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Row(
            children: [
              _PhotoItem(
                imageUrl: 'assets/images/family/send_back.jpg',
                category: '산책',
                date: '23',
                isSelected: true,
              ),
              const SizedBox(width: 16),
              _PhotoItem(
                imageUrl: 'assets/images/family/send_back.jpg',
                category: '사료',
                date: '23',
                isSelected: false,
              ),
              const SizedBox(width: 16),
              _PhotoItem(
                imageUrl: 'assets/images/family/send_back.jpg',
                category: '놀이',
                date: '23',
                isSelected: false,
              ),
              const SizedBox(width: 16),
              _PhotoItem(
                imageUrl: 'assets/images/family/send_back.jpg',
                category: '간식',
                date: '23',
                isSelected: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PhotoItem extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String date;
  final bool isSelected;
  
  const _PhotoItem({
    required this.imageUrl,
    required this.category,
    required this.date,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Photo container
        Container(
          width: 71,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Date overlay
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF95C6FF) : Color(0xFF95C6FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Category label
        Text(
          category,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF272727),
          ),
        ),
      ],
    );
  }
}
