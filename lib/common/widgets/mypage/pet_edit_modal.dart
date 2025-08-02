import 'package:daenglog_fe/models/mypage/pet_info.dart';
import 'package:flutter/material.dart';

class PetEditModal extends StatelessWidget {
  final VoidCallback onClose;
  final List<PetInfo> pets;
  final VoidCallback? onAddPet;
  final Function(PetInfo)? onSelectPet;

  const PetEditModal({
    super.key,
    required this.onClose,
    required this.pets,
    this.onAddPet,
    this.onSelectPet,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onClose,
      child: Container(
        color: Colors.black.withOpacity(0.77),
        child: Column(
          children: [
            // 상단 여백
            SizedBox(height: screenHeight * 0.6),
            
            // 모달 컨텐츠
            GestureDetector(
              onTap: () {}, // 모달 내부 탭 시 닫히지 않도록
              child: Container(
                height: screenHeight * 0.4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    // 드래그 핸들
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        width: screenWidth * 0.1,
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: screenHeight * 0.03),
                    
                    // 반려동물 목록 (스크롤 가능)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                        child: Column(
                          children: [
                            // 스크롤 가능한 반려동물 목록
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ...pets.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final pet = entry.value;
                                      return Column(
                                        children: [
                                          _buildPetEditItem(
                                            context, 
                                            pet.name, 
                                            pet.age, 
                                            pet.isRepresentative,
                                            () => onSelectPet?.call(pet),
                                          ),
                                          if (index < pets.length - 1) ...[
                                            SizedBox(height: screenHeight * 0.02),
                                            Container(
                                              height: 1,
                                              color: const Color(0xFFE7E7E7),
                                            ),
                                            SizedBox(height: screenHeight * 0.02),
                                          ],
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: screenHeight * 0.03),
                            // 반려동물 추가 버튼 (고정)
                            _buildAddPetButton(context),
                            SizedBox(height: screenHeight * 0.05),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 반려동물 수정 아이템
  Widget _buildPetEditItem(
    BuildContext context, 
    String name, 
    String age, 
    bool isRepresentative,
    VoidCallback? onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // 반려동물 이미지
          Container(
            width: screenWidth * 0.17,
            height: screenWidth * 0.17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              border: Border.all(
                color: const Color(0xFFADADAD),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.pets,
              color: Colors.grey[600],
              size: screenWidth * 0.08,
            ),
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // 반려동물 정보
          Expanded(
            child: Text(
              '$name | $age',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ),
          
          // 대표 표시
          if (isRepresentative) ...[
            Container(
              width: screenWidth * 0.028,
              height: screenWidth * 0.028,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5F01),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC4C4C4),
                  width: 0.5,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              '대표',
              style: TextStyle(
                fontSize: screenWidth * 0.034,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ] else ...[
            Container(
              width: screenWidth * 0.028,
              height: screenWidth * 0.028,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFC4C4C4),
                  width: 0.5,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.01),
            Text(
              '대표',
              style: TextStyle(
                fontSize: screenWidth * 0.034,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // 반려동물 추가 버튼
  Widget _buildAddPetButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onAddPet,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: const Color(0xFF5C5C5C),
              size: screenWidth * 0.075,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              '반려동물 추가',
              style: TextStyle(
                fontSize: screenWidth * 0.034,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
