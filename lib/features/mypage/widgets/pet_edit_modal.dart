import 'package:daenglog_fe/api/pets/models/pets_info.dart';
import 'package:flutter/material.dart';

class PetEditModal extends StatefulWidget {
  final VoidCallback onClose;
  final List<PetInfo> pets;
  final VoidCallback? onAddPet;
  final VoidCallback? onAddFamilyPet;
  final Function(PetInfo, int index)? onSelectPet;
  final Function(PetInfo)? onEditPet;
  final bool Function(PetInfo)? isFamilyShared;
  final bool showAddFamilyPet;
  final int Function(int index)? resolvePetId;
  final Future<void> Function(int index, PetInfo pet)? onSetDefault;

  const PetEditModal({
    super.key,
    required this.onClose,
    required this.pets,
    this.onAddPet,
    this.onAddFamilyPet,
    this.onSelectPet,
    this.onEditPet,
    this.isFamilyShared,
    this.showAddFamilyPet = false,
    this.resolvePetId,
    this.onSetDefault,
  });

  @override
  State<PetEditModal> createState() => _PetEditModalState();
}

class _PetEditModalState extends State<PetEditModal> with SingleTickerProviderStateMixin {
  int? selectedIndex;
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final initialIndex =
        widget.pets.indexWhere((p) => p.isRepresentative);
    selectedIndex = initialIndex >= 0 ? initialIndex : null;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _closeWithAnimation() async {
    try {
      await _controller.reverse();
    } catch (_) {}
    if (mounted) {
      widget.onClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: _closeWithAnimation,
      child: Container(
        color: Colors.black.withOpacity(0.77),
        child: Column(
          children: [
            // 상단 여백
            SizedBox(height: screenHeight * 0.35),
            
            // 모달 컨텐츠
            SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: () {}, // 모달 내부 탭 시 닫히지 않도록
                child: Container(
                  height: screenHeight * 0.65,
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
                        onTap: _closeWithAnimation,
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
                                      ...widget.pets.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final pet = entry.value;
                                        return Column(
                                          children: [
                                            _buildPetEditItem(
                                              context,
                                              pet.name,
                                              pet.age,
                                              pet.imageUrl,
                                              index,
                                              selectedIndex == index,
                                              () {
                                                setState(() {
                                                  selectedIndex = index;
                                                });
                                                widget.onSelectPet?.call(pet, index);
                                              },
                                              onEdit: () => widget.onEditPet?.call(pet),
                                              isFamilyShared: widget.isFamilyShared?.call(pet) ?? false,
                                              onTapRepresentative: () async {
                                                final shouldSet = await showDialog<bool>(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      title: const Text('대표 반려동물 설정'),
                                                      content: Text('${pet.name}을 대표 반려동물로 설정할까요?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.of(ctx).pop(false),
                                                          child: const Text('취소'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.of(ctx).pop(true),
                                                          child: const Text('설정'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                                if (shouldSet == true) {
                                                  setState(() { selectedIndex = index; });
                                                  await widget.onSetDefault?.call(index, pet);
                                                }
                                              },
                                            ),
                                            if (index < widget.pets.length - 1) ...[
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
                              if (widget.showAddFamilyPet) ...[
                                SizedBox(height: screenHeight * 0.012),
                                _buildAddFamilyPetButton(context),
                              ],
                              SizedBox(height: screenHeight * 0.05),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
    String? imageUrl,
    int index,
    bool isRepresentative,
    VoidCallback? onTap,
    {VoidCallback? onEdit, bool isFamilyShared = false, VoidCallback? onTapRepresentative}
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // 반려동물 이미지
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: screenWidth * 0.17,
                height: screenWidth * 0.17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFADADAD),
                    width: 1,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/home/default_profile.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/home/default_profile.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              if (isFamilyShared)
                Positioned(
                  right: -screenWidth * 0.01,
                  top: -screenWidth * 0.01,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.008),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.group,
                      size: screenWidth * 0.045,
                      color: const Color(0xFF5C5C5C),
                    ),
                  ),
                ),
            ],
          ),
          
          SizedBox(width: screenWidth * 0.04),
          
          // 반려동물 정보 + 나이 옆 수정 아이콘
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                      ),
                      Text(
                        ' | $age',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5C5C5C),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.008),
                      GestureDetector(
                        onTap: () {
                          onEdit?.call();
                          final petId = widget.resolvePetId?.call(index);
                          Navigator.pushNamed(
                            context,
                            '/pet_detail',
                            arguments: {
                              if (petId != null) 'id': petId,
                              'name': name,
                              'imageUrl': imageUrl,
                              'age': int.tryParse(age.replaceAll(RegExp(r'[^0-9]'), '')),
                            },
                          );
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.edit,
                          size: screenWidth * 0.045,
                          color: const Color(0x66666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // 대표 표시
          GestureDetector(
            onTap: onTapRepresentative,
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.028,
                  height: screenWidth * 0.028,
                  decoration: BoxDecoration(
                    color: isRepresentative ? const Color(0xFFFF5F01) : null,
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
            ),
          ),
        ],
      ),
    );
  }

  // 반려동물 추가 버튼
  Widget _buildAddPetButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/pet_info');
        widget.onAddPet?.call();
      },
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

  // 가족 반려동물 추가 버튼
  Widget _buildAddFamilyPetButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return GestureDetector(
      onTap: widget.onAddFamilyPet,
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
              '가족 반려동물 추가',
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
