import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_edit_modal.dart';
import 'package:daenglog_fe/api/pets/models/pets_info.dart';

class MyPageMainScreen extends StatefulWidget {
  const MyPageMainScreen({super.key});

  @override
  State<MyPageMainScreen> createState() => _MyPageMainScreenState();
}

class _MyPageMainScreenState extends State<MyPageMainScreen> {
  bool _showPetEditModal = false;
  
  // 반려동물 데이터
  final List<PetInfo> _pets = [
    PetInfo(name: '망고', age: '10살', isRepresentative: true),
    PetInfo(name: '나비', age: '7살', isRepresentative: false),
    PetInfo(name: '미등록', age: '0살', isRepresentative: false),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    return Scaffold(
      backgroundColor: const Color(0xFFFF5F01),
      body: Stack(
        children: [
          // 배경 그라데이션
          Container(
            width: double.infinity,
            height: screenHeight * 0.20, // 화면 높이의 35%
            decoration: const BoxDecoration(
              color: Color(0xFFFF5F01),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          // 메인 컨텐츠
          Column(
            children: [ 
              // 프로필 섹션
              _buildTopSection(context),
              SizedBox(height: screenHeight * 0.025),
              
              // 하단 화이트 섹션
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), 
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: _buildBottomSection(context),
                ),
              ),
            ],
          ),
          
          // 하단 네비게이션
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: commonBottomNavBar(
              context: context,
              currentIndex: 3,
            ),
          ),

          // 반려동물 수정 모달
          if (_showPetEditModal) 
            PetEditModal(
              onClose: () {
                setState(() {
                  _showPetEditModal = false;
                });
              },
              pets: _pets,
              onAddPet: () {
                // 반려동물 추가 로직
                print('반려동물 추가');
              },
              onSelectPet: (pets) {
                // 반려동물 선택 로직
                print('선택된 반려동물: ${(pets as PetInfo).name}');
              },
            ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------------------------

  // 프로필 섹션
  Widget _buildTopSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 반응형 패딩 계산
    final horizontalPadding = screenWidth * 0.1; // 화면 너비의 10%
    final topPadding = screenHeight * 0.08; // 화면 높이의 8%
    
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, topPadding, horizontalPadding, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          
          // 프로필 이미지와 텍스트를 Row로 배치
          Row(
            children: [
              // 프로필 이미지 및 카메라 아이콘
              Stack(
                children: [
                  Container(
                    width: screenWidth * 0.32, // 화면 너비의 32%
                    height: screenWidth * 0.32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: screenWidth * 0.01, // 화면 너비의 1%
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: screenWidth * 0.15, // 화면 너비의 15%
                      color: const Color(0xFF666666),
                    ),
                  ),
                  Positioned(
                    bottom: screenWidth * 0.025,
                    right: screenWidth * 0.025,
                    child: Container(
                      width: screenWidth * 0.08, // 화면 너비의 8%
                      height: screenWidth * 0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5F01),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: screenWidth * 0.04, // 화면 너비의 4%
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(width: screenWidth * 0.05), // 간격
              
              // 텍스트 부분을 Column으로 배치
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '망고 집사님,\n안녕하세요!',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06, // 화면 너비의 6%
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.02),
                    
                    // 프리미엄 배지
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.007,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(screenWidth * 0.018),
                      ),
                      child: Text(
                        '댕가족 플랜',
                        style: TextStyle(
                          fontSize: screenWidth * 0.029, // 화면 너비의 2.9%
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF5F01),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 흰색 배경 섹션
  Widget _buildBottomSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 반응형 패딩 계산
    final horizontalPadding = screenWidth * 0.1;
    final bottomPadding = screenHeight * 0.12; // 하단 네비게이션 고려
    
    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, screenHeight * 0.05, horizontalPadding, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 내 반려동물 섹션
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '내 반려동물',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05, // 화면 너비의 5%
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF484848),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showPetEditModal = true;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      '수정',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035, // 화면 너비의 3.5%
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9A9A9A),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Transform.rotate(
                      angle: 270 * 3.14159 / 180,
                      child: Icon(
                        Icons.chevron_right,
                        size: screenWidth * 0.04,
                        color: const Color(0xFF9A9A9A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Text(
            '반려동물 선택 시 대표 반려동물로 설정됩니다.',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: const Color(0xFF9A9A9A),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          
          // 반려동물 선택 -> api 연동 후 수정 필요 (선택시 대표 반려동물로 설정)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPetCard(context, '망고', true),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '나비', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
                SizedBox(width: screenWidth * 0.05),
                _buildPetCard(context, '미등록', false),
              ],
            ),
          ),
          
          SizedBox(height: screenHeight * 0.025),
          
          
          SizedBox(height: screenHeight * 0.05),
          
          // 메뉴 아이템
          _buildMenuItem(context, '내정보 관리', Icons.person_outline, '/my_info_page'),
          _buildMenuItem(context, '이벤트/혜택', Icons.card_giftcard, '/event'),
          _buildMenuItem(context, '요금제 관리', Icons.payment, '/cloud_main'),
          _buildMenuItem(context, '공지사항', Icons.announcement, '/notice'),
          _buildMenuItem(context, '고객센터', Icons.help_outline, '/customer_center'),
          
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
          
          // 버전
          Center(
            child: Text(
              'Ver 1.01',
              style: TextStyle(
                fontSize: screenWidth * 0.025,
                color: const Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------------------------

  // 내 반려동물 카드
  Widget _buildPetCard(BuildContext context, String name, bool isSelected) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      children: [
        Container(
          width: screenWidth * 0.15, 
          height: screenWidth * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFFFF5F01) : Colors.grey[300],
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5F01) : Colors.grey[400]!,
              width: screenWidth * 0.005,
            ),
          ),
          child: Icon(
            Icons.pets,
            color: isSelected ? Colors.white : Colors.grey[600],
            size: screenWidth * 0.075,
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.023,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF5C5C5C),
          ),
        ),
      ],
    );
  }

  // 메뉴 아이템 (내정보 관리, 이벤트/혜택, 요금제 관리, 공지사항, 고객센터)
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF484848),
            size: screenWidth * 0.05,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF484848),
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: screenWidth * 0.03,
            color: const Color(0xFF9A9A9A),
          ),
          ],
        ),
      ),
    );
  }


}