import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';

class ChatGptPhotoCard extends StatelessWidget {
  final String formattedDate;
  final DiaryGptResponse? gptResponse;

  const ChatGptPhotoCard({
    Key? key,
    required this.formattedDate,
    required this.gptResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gptResponse == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 반응형 값 계산
    final avatarSize = screenWidth * 0.1; // 화면 너비의 10%
    final avatarMargin = screenHeight * 0.015; // 화면 높이의 1.5%
    final avatarIconSize = avatarSize * 0.6; // 아바타 크기의 60%
    final spacing = screenWidth * 0.04; // 화면 너비의 4%
    final cardMargin = screenHeight * 0.04; // 화면 높이의 4%
    final cardPadding = screenWidth * 0.05; // 화면 너비의 5%
    final borderRadius = screenWidth * 0.04; // 화면 너비의 4%
    final titleFontSize = screenWidth * 0.045; // 화면 너비의 4.5%
    final contentFontSize = screenWidth * 0.038; // 화면 너비의 3.8%
    final buttonFontSize = screenWidth * 0.035; // 화면 너비의 3.5%
    final titleSpacing = screenHeight * 0.015; // 화면 높이의 1.5%
    final contentSpacing = screenHeight * 0.02; // 화면 높이의 2%
    final buttonHeight = screenHeight * 0.04; // 화면 높이의 4%
    final buttonWidth = screenWidth * 0.28; // 화면 너비의 28%
    final buttonPadding = screenWidth * 0.01; // 화면 너비의 1%
    final buttonBorderRadius = screenWidth * 0.01; // 화면 너비의 1%
    final iconSize = screenWidth * 0.038; // 화면 너비의 3.8%

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽 동그란 아이콘
        Container(
          margin: EdgeInsets.only(top: avatarMargin),
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7F3),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF6600), width: 2),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/home/daeng.png',
              width: avatarIconSize,
              height: avatarIconSize,
            ),
          ),
        ),
        SizedBox(width: spacing),
        // 오른쪽 카드
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: cardMargin),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF5F01), width: 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(borderRadius),
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              cardPadding, 
              cardPadding, 
              cardPadding, 
              cardPadding * 0.8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제목
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${gptResponse!.title} 🦴",
                        style: TextStyle(
                          fontFamily: 'Suite-ExtraBold',
                          fontWeight: FontWeight.w900,
                          fontSize: titleFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: titleSpacing),
                // 본문
                Text(
                  gptResponse!.content.replaceAll("\n", " "), // null이 아님 보장 + 빈 문자열 처리 + 본문 
                  style: TextStyle(
                    fontSize: contentFontSize,
                    color: Colors.black87,
                    fontFamily: 'Yeongdeok-Sea',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: contentSpacing),
                // 포토카드 보기 버튼
                SizedBox(
                  height: buttonHeight,
                  width: buttonWidth,
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, '/chat_photo', arguments: gptResponse);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEEE8),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonBorderRadius),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: buttonPadding, 
                        horizontal: buttonPadding
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '포토카드 보기',
                          style: TextStyle(
                            color: const Color(0xFF5C5C5C),
                            fontFamily: 'Suite-Regular',
                            fontWeight: FontWeight.w600,
                            fontSize: buttonFontSize,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.005), // 화면 너비의 0.5%
                        Icon(
                          Icons.arrow_forward_ios, 
                          size: iconSize, 
                          color: const Color(0xFF5C5C5C)
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}