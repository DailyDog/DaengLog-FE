import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/information.widgets/pet_info.dart';

class PetInformationKind extends StatelessWidget {
  const PetInformationKind({Key? key}) : super(key: key);
// _의 의미 : 클래스 내부에서만 사용하는 클래스

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      currentStep: null,
      title: '종을',
      titleSub: ' 선택해 주세요!',
      subtitle: 'AI에게 전달되는 정보에요.',
      onPrevious: () {
        Navigator.pushNamed(context, '/pet_information_kind');
      },
      onNext: () {
        Navigator.pushNamed(context, '/pet_information_name');
      },
      child: Center(
        child: Container(
          height: 48,
          width: 300,
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0), // 연한 회색 배경
            borderRadius: BorderRadius.circular(48), // 양쪽 라운드
          ),
          child: Center(
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none, // 내부 border 제거
                hintText: '강아지 이름',
                hintStyle: TextStyle(
                  color: Color(0xFF8C8B8B),
                  fontSize: 16,
                  fontFamily: 'Pretendard-Medium',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
