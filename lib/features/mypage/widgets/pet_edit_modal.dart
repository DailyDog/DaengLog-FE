import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/pets/models/pets_info.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';

class PetEditModal extends StatefulWidget {
  final VoidCallback onClose;
  final List<PetInfo> pets;
  final VoidCallback? onAddPet;
  final Function(PetInfo, int)? onSelectPet;
  final Function(PetInfo)? onEditPet;
  final bool Function(PetInfo)? isFamilyShared;
  final bool showAddFamilyPet;
  final int Function(int)? resolvePetId;
  final Future<void> Function(int, PetInfo)? onSetDefault;

  const PetEditModal({
    super.key,
    required this.onClose,
    required this.pets,
    this.onAddPet,
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
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pets.indexWhere((p) => p.isRepresentative);
    if (selectedIndex == -1) selectedIndex = null;
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    await _controller.reverse();
    if (mounted) widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: _close,
      child: Container(
        color: Colors.black54,
        child: Column(
          children: [
            SizedBox(height: size.height * 0.35),
            SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: () {}, // 모달 내부 클릭 방지
                child: Container(
                  height: size.height * 0.65,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      _buildHandle(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.separated(
                                  itemCount: widget.pets.length,
                                  separatorBuilder: (_, __) => const Divider(height: 32),
                                  itemBuilder: (context, index) => _PetItem(
                                    pet: widget.pets[index],
                                    isSelected: selectedIndex == index,
                                    isFamilyShared: widget.isFamilyShared?.call(widget.pets[index]) ?? false,
                                    onTap: () {
                                      setState(() => selectedIndex = index);
                                      widget.onSelectPet?.call(widget.pets[index], index);
                                    },
                                    onEdit: () {
                                      final petId = widget.resolvePetId?.call(index);
                                      Navigator.pushNamed(
                                        context,
                                        '/pet_detail',
                                        arguments: {'id': petId},
                                      );
                                    },
                                    onSetDefault: () => _handleSetDefault(index),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _AddPetButton(onTap: widget.onAddPet),
                              if (widget.showAddFamilyPet) ...[
                                const SizedBox(height: 12),
                                _AddPetButton(
                                  label: '가족 반려동물 추가',
                                  onTap: () => Navigator.pushNamed(context, '/pet_family_add'),
                                ),
                              ],
                              const SizedBox(height: 40),
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

  Widget _buildHandle() {
    return GestureDetector(
      onTap: _close,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Future<void> _handleSetDefault(int index) async {
    final shouldSet = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ConfirmDialog(
        title: '대표 반려동물 설정',
        content: '대표 반려동물을 변경할까요?',
        confirmText: '설정',
      ),
    );
    
    if (shouldSet == true) {
      setState(() => selectedIndex = index);
      await widget.onSetDefault?.call(index, widget.pets[index]);
    }
  }
}

// 반려동물 아이템 위젯
class _PetItem extends StatelessWidget {
  final PetInfo pet;
  final bool isSelected;
  final bool isFamilyShared;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;

  const _PetItem({
    required this.pet,
    required this.isSelected,
    required this.isFamilyShared,
    required this.onTap,
    required this.onEdit,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          // 프로필 이미지 - PetAvatar 사용
          Stack(
            clipBehavior: Clip.none,
            children: [
              PetAvatar(
                imageUrl: pet.imageUrl,
                size: 68,
                petId: pet.id, // petId 전달로 403 에러 시 자동 갱신
              ),
              if (isFamilyShared)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                    ),
                    child: const Icon(Icons.group, size: 18, color: Colors.grey),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          
          // 정보
          Expanded(
            child: Row(
              children: [
                Text(
                  '${pet.name} | ${pet.age}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5C5C5C),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(Icons.edit, size: 20, color: Colors.grey),
                ),
              ],
            ),
          ),
          
          // 대표 설정
          GestureDetector(
            onTap: onSetDefault,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF5F01) : null,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  '대표',
                  style: TextStyle(fontSize: 14, color: Color(0xFF5C5C5C)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 추가 버튼 위젯
class _AddPetButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _AddPetButton({
    this.label = '반려동물 추가',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Color(0xFF5C5C5C), size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF5C5C5C)),
            ),
          ],
        ),
      ),
    );
  }
}

// 확인 다이얼로그
class _ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;

  const _ConfirmDialog({
    required this.title,
    required this.content,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('취소', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(confirmText, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}