import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/onboding/widgets/onboding_widget.dart';

class OnbodingTrd extends StatelessWidget {
  const OnbodingTrd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildOnboardingContent(
        titleHighlight: '마켓',
        subtitle: '반려동물이 먹고 싶어한 간식이나 \n용품을 앱 내에서 편리하게 구매하세요!',
        imagePath: 'assets/images/onboding/onboding_trd.png',
        indicatorIndex: 2,
        context: context,
        navigationButtonText: '/onboding_fth',
    );
  }
}
