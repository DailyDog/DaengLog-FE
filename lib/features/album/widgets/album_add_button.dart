import 'package:flutter/material.dart';

/// 앨범 추가하기 버튼 위젯
/// 
/// 앨범 상세 화면 하단에 표시되는 "추가하기" 버튼입니다.
/// 앨범에 새로운 사진/일기를 추가하는 기능을 담당합니다.
/// 
/// Figma 디자인: 4-1.1-4 앨범 상세 페이지 (하단 추가하기 버튼)
class AlbumAddButton extends StatelessWidget {
  const AlbumAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // TODO: 추가하기 기능 구현 필요
          // 기능: 앨범에 사진/일기를 추가하는 모달 또는 화면 표시
          // 옵션 1: 사진 선택 모달 (갤러리에서 선택)
          // 옵션 2: 일기 선택 화면으로 이동
          // 옵션 3: 직접 사진 촬영 기능
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            // 주황색 테두리 (Figma 디자인 기준)
            border: Border.all(
              color: const Color(0xFFFF5F01), // 주황색
              width: 1.93, // Figma 디자인 기준 두께
            ),
            borderRadius: BorderRadius.circular(34.68), // Figma 디자인 기준 둥근 모서리
          ),
          child: const Text(
            '추가하기',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF5F01), // 주황색 텍스트
            ),
          ),
        ),
      ),
    );
  }
}

