import 'package:flutter/material.dart';

class PastPhotoItem extends StatelessWidget {
  final String imagePath;
  final String date;

  const PastPhotoItem({
    required this.imagePath,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
