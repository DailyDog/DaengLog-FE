import 'package:flutter/material.dart';

class MyInfoPage extends StatelessWidget {
  const MyInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.02),

            // 프로필 섹션
            _buildProfileSection(context),
            SizedBox(height: screenHeight * 0.05),
            
            // 회원정보 섹션
            _buildMemberInfoSection(context),
            SizedBox(height: screenHeight * 0.05),
            
            // 설정 섹션
            _buildSettingsSection(context),
            SizedBox(height: screenHeight * 0.05),
            
            // 하단 버튼들
            _buildBottomButtons(context),
            SizedBox(height: screenHeight * 0.05),
          ],
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
        onTap: () => Navigator.pop(context),
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
        '내 정보 관리',
        style: TextStyle(
          fontSize: screenWidth * 0.055,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  // 프로필 섹션
  Widget _buildProfileSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        // 프로필 이미지
        Stack(
          children: [
            Container(
              width: screenWidth * 0.2,
              height: screenWidth * 0.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: Icon(
                Icons.person,
                size: screenWidth * 0.1,
                color: Colors.grey[600],
              ),
            ),
            Positioned(
              bottom: screenWidth * 0.02,
              right: screenWidth * 0.02,
              child: Container(
                width: screenWidth * 0.06,
                height: screenWidth * 0.06,
                decoration: const BoxDecoration(
                  color: Color(0xFF03C75A),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: screenWidth * 0.03,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: screenHeight * 0.02),
        
        // 닉네임
        Text(
          '토미',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF484848),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.01),
        
        // 로그인 방식
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.005,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF03C75A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Naver 로그인',
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // 회원정보 섹션
  Widget _buildMemberInfoSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '회원정보',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5C5C5C),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.025,
                  vertical: screenHeight * 0.005,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFCDCDCD),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '수정',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // 구분선
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
          
          SizedBox(height: screenHeight * 0.03),
          
          // 회원정보 항목들
          _buildInfoItem(context, '닉네임', '토미'),
          _buildInfoItem(context, '이름', '김태현'),
          _buildInfoItem(context, '생년월일', '2001년 11월 21일'),
          _buildInfoItem(context, '이메일', 'helloworld@naver.com'),
        ],
      ),
    );
  }

  // 회원정보 항목
  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.025),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨
          SizedBox(
            width: screenWidth * 0.2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7B7B7B),
              ),
            ),
          ),
          
          SizedBox(width: screenWidth * 0.02),
          
          // 값
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 설정 섹션
  Widget _buildSettingsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
      child: Column(
        children: [
          // 자동 로그인 기기 설정
          _buildSettingItem(
            context,
            '자동 로그인 기기 설정',
            () {
              // 자동 로그인 기기 설정 페이지로 이동
            },
          ),
          
          // 구분선
          Container(
            height: 1,
            color: const Color(0xFFF0F0F0),
          ),
          
          // 알림 설정
          _buildSettingItem(
            context,
            '알림 설정',
            () => Navigator.pushNamed(context, '/alarm_page'),
          ),
        ],
      ),
    );
  }

  // 설정 항목
  Widget _buildSettingItem(BuildContext context, String title, VoidCallback onTap) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7B7B7B),
              ),
            ),
            Transform.rotate(
              angle: 270 * 3.14159 / 180,
              child: Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04,
                color: const Color(0xFF9A9A9A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 버튼들
    Widget _buildBottomButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        // 로그아웃 버튼
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD4B0),
              borderRadius: BorderRadius.circular(screenWidth * 0.15),
            ),
            child: Text(
              '로그아웃',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.03),
        
        // 회원탈퇴 안내 텍스트
        Text(
          '회원정보를 완전히 삭제하고 싶으신가요?',
          style: TextStyle(
            fontSize: screenWidth * 0.028,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCDCDCD),
          ),
        ),
        
        SizedBox(height: screenHeight * 0.01),
        
        // 회원탈퇴 버튼
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025,
              vertical: screenHeight * 0.001,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFCDCDCD),
              borderRadius: BorderRadius.circular(screenWidth * 0.12),
            ),
            child: Text(
              '회원탈퇴',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
