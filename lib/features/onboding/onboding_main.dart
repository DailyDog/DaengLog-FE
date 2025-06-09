import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/onboding.widgets/onboding.dart';

class OnbodingMain extends StatelessWidget {
  const OnbodingMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildOnboardingContent(
      titleHighlight: '메인',
      subtitle: '반려동물의 사진으로 \n속마음을 읽어보세요!',
      imagePath: 'assets/images/onboding/onboding_first.png',
      indicatorIndex: 0,
      context: context,
      navigationButtonText: '/onboding_sec',
    );
  }
}
