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
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Stack(
          children: [
            // 메인 컨텐츠
            SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 프로필 섹션
                  _buildProfileSection(context),
                  
                  // 반려동물 섹션
                  _buildPetSection(context),
                  
                  // 메뉴 섹션
                  _buildMenuSection(context),
                  
                  // 하단 여백 (네비게이션 바 공간)
                  SizedBox(height: screenHeight * 0.12),
                ],
              ),
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
      ),
    );
  }

//------------------------------------------------------------------------------------------------

  // 상단 프로필 섹션
  Widget _buildProfileSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFF5F01),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          screenWidth * 0.06, 
          screenHeight * 0.02, 
          screenWidth * 0.06, 
          screenHeight * 0.03
        ),
        child: Row(
          children: [
            // 프로필 이미지
            Stack(
              children: [
                Container(
                  width: screenWidth * 0.22,
                  height: screenWidth * 0.22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: screenWidth * 0.12,
                    color: const Color(0xFF666666),
                  ),
                ),
                // 카메라 아이콘
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: screenWidth * 0.07,
                    height: screenWidth * 0.07,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5F01),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: screenWidth * 0.035,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(width: screenWidth * 0.04),
            
            // 프로필 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '망고 집사님,\n안녕하세요!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.015),
                  
                  // 플랜 배지
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.025,
                      vertical: screenHeight * 0.006,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '댕가족 플랜',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFF5F01),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 반려동물 섹션
  Widget _buildPetSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.06),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 내 반려동물 헤더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '내 반려동물',
                style: TextStyle(
                  fontSize: screenWidth * 0.048,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2D2D2D),
                  fontFamily: 'Pretendard',
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
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9A9A9A),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Icon(
                      Icons.edit_outlined,
                      size: screenWidth * 0.04,
                      color: const Color(0xFF9A9A9A),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: screenHeight * 0.01),
          
          Text(
            '반려동물 선택 시 대표 반려동물로 설정됩니다.',
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: const Color(0xFF9A9A9A),
              fontFamily: 'Pretendard',
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // 반려동물 목록
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _pets.asMap().entries.map((entry) {
                final index = entry.key;
                final pet = entry.value;
                return Row(
                  children: [
                    _buildPetCard(context, pet.name, pet.isRepresentative),
                    if (index < _pets.length - 1) 
                      SizedBox(width: screenWidth * 0.04),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // 메뉴 섹션
  Widget _buildMenuSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(context, '내정보 관리', Icons.person_outline, '/my_info_page'),
          _buildDivider(),
          _buildMenuItem(context, '이벤트/혜택', Icons.card_giftcard_outlined, '/event'),
          _buildDivider(),
          _buildMenuItem(context, '요금제 관리', Icons.payment_outlined, '/cloud_main'),
          _buildDivider(),
          _buildMenuItem(context, '공지사항', Icons.announcement_outlined, '/notice'),
          _buildDivider(),
          _buildMenuItem(context, '고객센터', Icons.help_outline, '/customer_center'),
          
          SizedBox(height: screenHeight * 0.03),
          
          // 로그아웃 버튼
          GestureDetector(
            onTap: () {
              // 로그아웃 로직
              print('로그아웃');
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.015,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8D6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF5F01).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  '로그아웃',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFF5F01),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // 앱 버전
          Center(
            child: Text(
              'Ver 1.01',
              style: TextStyle(
                fontSize: screenWidth * 0.028,
                color: const Color(0xFFBBBBBB),
                fontFamily: 'Pretendard',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 내 반려동물 카드
  Widget _buildPetCard(BuildContext context, String name, bool isSelected) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: () {
        // 반려동물 선택 로직
        setState(() {
          // 대표 반려동물 변경 로직 구현 필요
        });
      },
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.16,
            height: screenWidth * 0.16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFF5F5F5),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF5F01) : const Color(0xFFE0E0E0),
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFFFF5F01).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : [],
            ),
            child: Icon(
              Icons.pets,
              color: isSelected ? Colors.white : const Color(0xFF9A9A9A),
              size: screenWidth * 0.08,
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          Text(
            name,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? const Color(0xFF2D2D2D) : const Color(0xFF9A9A9A),
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }

  // 메뉴 아이템
  Widget _buildMenuItem(BuildContext context, String title, IconData icon, String route) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF2D2D2D),
              size: screenWidth * 0.055,
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D2D2D),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: screenWidth * 0.045,
              color: const Color(0xFFBBBBBB),
            ),
          ],
        ),
      ),
    );
  }

  // 구분선
  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFF0F0F0),
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}