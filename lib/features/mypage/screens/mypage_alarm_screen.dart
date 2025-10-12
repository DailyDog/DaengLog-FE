import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // 알림 설정 상태들
  bool _pushNotification = true;
  bool _deviceNotification = true;
  bool _diaryNotification = true;
  bool _letterNotification = true;
  bool _familyLetterNotification = true;
  bool _smsNotification = true;
  bool _emailNotification = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // 푸시 / 문자 / 이메일
              _buildNotificationSection(
                context,
                '푸시 / 문자/ 이메일',
                _pushNotification,
                (value) {
                  setState(() {
                    _pushNotification = value;
                  });
                },
              ),

              // 구분선
              Container(
                height: 1,
                color: const Color(0xFFF0F0F0),
              ),

              // 기기 알림 설정
              _buildNotificationSection(
                context,
                '기기 알림 설정',
                _deviceNotification,
                (value) {
                  setState(() {
                    _deviceNotification = value;
                  });
                },
                description:
                    '기기 알림을 켜시면 일기 생성 알림, 반려동물 편지 등\n다양한 소식을 받아보실 수 있어요.',
              ),

              // 일기 알림
              _buildNotificationSection(
                context,
                '일기 알림',
                _diaryNotification,
                (value) {
                  setState(() {
                    _diaryNotification = value;
                  });
                },
                description: '일기 생성이 완료되거나, 일기 생성이 필요할 때 알려드려요.',
              ),

              // 편지 알림
              _buildNotificationSection(
                context,
                '편지 알림',
                _letterNotification,
                (value) {
                  setState(() {
                    _letterNotification = value;
                  });
                },
                description: '데이터 기반 반려동물이 직접 쓰는 편지를 알림으로 보내드려요.',
              ),

              // 가족편지 알림
              _buildNotificationSection(
                context,
                '가족편지 알림',
                _familyLetterNotification,
                (value) {
                  setState(() {
                    _familyLetterNotification = value;
                  });
                },
                description: '가족 구성원이 보내는 일기나 편지를 알림으로 보내드려요.',
              ),

              // 문자 / 이메일
              _buildNotificationSection(
                context,
                '문자 / 이메일',
                _smsNotification,
                (value) {
                  setState(() {
                    _smsNotification = value;
                  });
                },
                description: '다양한 혜택과 이벤트 알림',
              ),

              SizedBox(height: screenHeight * 0.02),

              // 문자
              _buildSubNotificationSection(
                context,
                '문자',
                _smsNotification,
                (value) {
                  setState(() {
                    _smsNotification = value;
                  });
                },
              ),

              // 이메일
              _buildSubNotificationSection(
                context,
                '이메일',
                _emailNotification,
                (value) {
                  setState(() {
                    _emailNotification = value;
                  });
                },
              ),

              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: const Color(0xFFFF5F01),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/mypage');
          }
        },
        child: Transform.rotate(
          angle: 90 * 3.14159 / 180,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: screenWidth * 0.05,
          ),
        ),
      ),
      title: Text(
        '알림 설정',
        style: TextStyle(
          fontSize: screenWidth * 0.055,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  // 알림 섹션
  Widget _buildNotificationSection(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    String? description,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목과 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7B7B7B),
                  ),
                ),
                if (description != null) ...[
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF9A9A9A),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(width: screenWidth * 0.02),

          // 토글 스위치
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF5F01),
            activeTrackColor: const Color(0xFFFF5F01).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  // 하위 알림 섹션 (문자, 이메일)
  Widget _buildSubNotificationSection(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      child: Row(
        children: [
          // 제목
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF7B7B7B),
            ),
          ),

          const Spacer(),

          // 토글 스위치
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF5F01),
            activeTrackColor: const Color(0xFFFF5F01).withOpacity(0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
