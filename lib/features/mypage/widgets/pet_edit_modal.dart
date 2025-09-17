import 'package:daenglog_fe/api/pets/models/pets_info.dart';
import 'package:flutter/material.dart';

class PetEditModal extends StatelessWidget {
  final VoidCallback onClose;
  final List<PetInfo> pets;
  final VoidCallback? onAddPet;
  final VoidCallback? onAddFamilyPet;
  final Function(PetInfo)? onSelectPet;
  final int representativeIndex;
  final PetInfo? representativePet;
  final bool hasFamilyService;

  const PetEditModal({
    super.key,
    required this.onClose,
    required this.pets,
    this.onAddPet,
    this.onAddFamilyPet,
    this.onSelectPet,
    required this.representativeIndex,
    this.representativePet,
    required this.hasFamilyService,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.black.withOpacity(0.77), // dimmed barrier
      child: Stack(
        children: [
          // 배리어 탭 → 닫기
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onClose,
            ),
          ),

          // 하단 시트
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                constraints: BoxConstraints(
                  // 기기별 안정적 비율 (최대 60% 높이)
                  maxHeight: screenHeight * 0.6,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 드래그 핸들
                    GestureDetector(
                      onTap: onClose,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: screenWidth * 0.12,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 스크롤 영역
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                        child: ListView.separated(
                          itemCount: pets.length,
                          separatorBuilder: (_, __) => Column(
                            children: [
                              SizedBox(height: screenHeight * 0.015),
                              Container(height: 1, color: const Color(0xFFE7E7E7)),
                              SizedBox(height: screenHeight * 0.015),
                            ],
                          ),
                          itemBuilder: (context, index) {
                            final pet = pets[index];

                            // 대표 표시 기준: 상위에서 내려준 representativeIndex 사용
                            final isRep = index == representativeIndex;

                            return _buildPetEditItem(
                              context: context,
                              pet: pet,
                              isRepresentative: isRep,
                              onTap: () => onSelectPet?.call(pet),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),

                    // 하단 버튼들
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                      child: Column(
                        children: [
                          // 기본 반려동물 추가 버튼 (항상)
                          _buildAddPetButton(
                            context,
                            label: '반려동물 추가',
                            onTap: onAddPet,
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // 가족 반려동물 추가 버튼 (조건부)
                          if (hasFamilyService)
                            _buildAddPetButton(
                              context,
                              label: '가족 반려동물 추가',
                              onTap: onAddFamilyPet ??
                                  () {
                                    // 필요 시 기본 동작
                                    debugPrint('가족 반려동물 추가');
                                  },
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 두 Pet이 동일한지 비교 (id가 있으면 id로, 없으면 name+age로 비교)
  bool _isSamePet(PetInfo a, PetInfo? b) {
    if (b == null) return false;
    try {
      // id 필드가 있는 경우 대비 (dynamic 접근)
      final dynamic da = a;
      final dynamic db = b;
      if ((da as dynamic).id != null && (db as dynamic).id != null) {
        return da.id == db.id;
      }
    } catch (_) {
      // id가 없으면 아래로 폴백
    }
    // 폴백: name + age 비교
    try {
      return a.name == b.name && a.age == b.age;
    } catch (_) {
      return false;
    }
  }

  // 반려동물 수정 아이템
  Widget _buildPetEditItem({
    required BuildContext context,
    required PetInfo pet,
    required bool isRepresentative,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          // 아바타
          Container(
            width: screenWidth * 0.17,
            height: screenWidth * 0.17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
              border: Border.all(color: const Color(0xFFADADAD), width: 1),
            ),
            child: Icon(
              Icons.pets,
              color: Colors.grey[600],
              size: screenWidth * 0.08,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),

          // 이름 | 나이
          Expanded(
            child: Text(
              '${pet.name} | ${pet.age}',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5C5C5C),
              ),
            ),
          ),

          // 대표 표시 (라디오 느낌)
          Container(
            width: screenWidth * 0.028,
            height: screenWidth * 0.028,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRepresentative ? const Color(0xFFFF5F01) : null,
              border: Border.all(color: const Color(0xFFC4C4C4), width: 0.5),
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
      ),
    );
  }

  // 공용 추가 버튼
  Widget _buildAddPetButton(
    BuildContext context, {
    required String label,
    VoidCallback? onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.012,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: const Color(0xFF5C5C5C), size: screenWidth * 0.075),
            SizedBox(width: screenWidth * 0.02),
            Text(
              label,
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