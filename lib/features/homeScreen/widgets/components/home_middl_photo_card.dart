import 'package:flutter/material.dart';

// 메인화면 포토카드 위잿
class HomeMiddlePhotoCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String keyword;

  const HomeMiddlePhotoCard({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.keyword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.1),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Text(
              date,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [Shadow(blurRadius: 2, color: Colors.black)],
              ),
            ),
          ),
          Positioned(
            left: 12,
            bottom: 16,
            child: Text(
              keyword,
            ),
          ),
        ],
      ),
    );
  }
}
