import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FamilyMembersWidget extends StatelessWidget {
  const FamilyMembersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 화면 크기에 따른 동적 크기 계산
    final containerWidth = screenWidth * 0.85;
    final avatarSize = screenWidth * 0.08;
    final crownSize = screenWidth * 0.035;
    
    return Container(
      width: containerWidth,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '우리가족 구성원',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
              color: Color(0xFF272727),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Expanded(
                child: Text(
                  '4명의 구성원이 포함되어 있습니다.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.032,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8B8B),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.push('/invite-member-main');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFF757575), width: 0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '+ 추가',
                    style: TextStyle(
                      fontSize: screenWidth * 0.022,
                      color: Color(0xFF272727),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFC9C9C9)),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 아빠 (결제자)
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(avatarSize / 2),
                                ),
                                child: Icon(Icons.person, color: Colors.grey[600]),
                              ),
                              Positioned(
                                top: -2,
                                left: 0,
                                child: Icon(
                                  Icons.star,
                                  size: crownSize,
                                  color: Color(0xFFFFD700),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '아빠',
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: Color(0xFF272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 엄마
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(avatarSize / 2),
                            ),
                            child: Icon(Icons.person, color: Colors.grey[600]),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '엄마',
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: Color(0xFF272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 누나
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(avatarSize / 2),
                            ),
                            child: Icon(Icons.person, color: Colors.grey[600]),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '누나',
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: Color(0xFF272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 형
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(avatarSize / 2),
                            ),
                            child: Icon(Icons.person, color: Colors.grey[600]),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '형',
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              color: Color(0xFF272727),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '가족결제',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF272727),
                      ),
                    ),
                    Text(
                      '아빠님이 결제중',
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Color(0xFF272727),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
