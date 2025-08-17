import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/onboding/widgets/onboding_widget.dart';

class OnbodingFth extends StatelessWidget {
  const OnbodingFth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return buildOnboardingContent(
      titleHighlight: '클라우드',
      subtitle: '반려동물 사진은 안전하게 보관, \n내 핸드폰 저장공간은 UP!',
      imagePath: 'assets/images/onboding/onboding_fth.png',
      indicatorIndex: 3,
      context: context,
      navigationButtonText: '/login',
    );
  }
}
