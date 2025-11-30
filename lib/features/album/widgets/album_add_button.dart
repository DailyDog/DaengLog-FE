import 'package:flutter/material.dart';

class AlbumAddButton extends StatelessWidget {
  const AlbumAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: 추가하기 기능 구현
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFFF5F01),
              width: 1.93,
            ),
            borderRadius: BorderRadius.circular(34.68),
          ),
          child: const Text(
            '추가하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF5F01),
            ),
          ),
        ),
      ),
    );
  }
}

