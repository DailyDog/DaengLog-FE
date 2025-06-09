import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/onboding.widgets/onboding.dart';

class OnbodingSec extends StatelessWidget {
  const OnbodingSec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildOnboardingContent(
        titleHighlight: '기록',
        subtitle: '날짜별 반려동물의 생각을 \n캘린더에 사진과 함께 저장해 보세요!',
        imagePath: 'assets/images/onboding/onboding_sec.png',
        indicatorIndex: 1,
        context: context,
        navigationButtonText: '/onboding_trd',
      );
  }
}
