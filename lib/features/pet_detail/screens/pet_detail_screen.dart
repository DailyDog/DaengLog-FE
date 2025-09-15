import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  Map<String, dynamic>? _detail;
  bool _loading = true;
  int? _petId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _petId = args?['id'] as int?;
    
    if (_petId == null) {
      setState(() {
        _detail = args;
        _loading = false;
      });
      return;
    }

    final provider = context.read<PetProfileProvider>();
    final detail = await provider.loadPetDetail(_petId!);
    
    if (mounted) {
      setState(() {
        _detail = detail ?? args;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF5F01)))
          : _detail == null
              ? _buildErrorView()
              : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFF5F01),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        _detail?['name'] ?? '반려동물 상세',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('데이터를 불러올 수 없습니다'),
          TextButton(
            onPressed: _loadData,
            child: const Text('다시 시도', style: TextStyle(color: Color(0xFFFF5F01))),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.08;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _ProfileSection(detail: _detail!),
          const SizedBox(height: 30),
          _InfoSection(
            detail: _detail!,
            onEdit: () => _navigateToEdit('/pet_basic_edit'),
          ),
          const SizedBox(height: 30),
          _PersonalitySection(
            detail: _detail!,
            onEdit: () => _navigateToEdit('/pet_personality_edit'),
          ),
          const SizedBox(height: 50),
          const Divider(color: Color(0xFFEFEFEF)),
          const SizedBox(height: 30),
          _DeleteButton(onDelete: () => _handleDelete(context, _petId)),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void _navigateToEdit(String route) {
    Navigator.pushNamed(
      context,
      route,
      arguments: _detail,
    ).then((changed) {
      if (changed == true && _petId != null) {
        _loadData();
      }
    });
  }
}

// _ProfileSection 위젯 (카메라 버튼 추가)
class _ProfileSection extends StatelessWidget {
  final Map<String, dynamic> detail;
  
  const _ProfileSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<PetProfileProvider>();
    final petId = detail['id'] as int?;
    final imageUrl = petId != null 
        ? provider.getPetImage(petId) 
        : detail['profileImageUrl'] as String?;
    
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // 기존의 PetAvatar
            PetAvatar(
              imageUrl: imageUrl,
              size: size.width * 0.36,
              petId: petId,
            ),
            // 카메라 버튼
            Positioned(
              bottom: -8,
              right: -8,
              child: GestureDetector(
                onTap: () => _showImagePicker(context, petId),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F01),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, 
                        blurRadius: 6, 
                        offset: Offset(0, 2)
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera, 
                    color: Colors.white, 
                    size: 20
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          detail['name'] ?? '',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF484848),
          ),
        ),
      ],
    );
  }

  void _showImagePicker(BuildContext context, int? petId) {
    if (petId == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery, petId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera, petId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source, int petId) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      
      if (image != null) {
        // 로딩 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF5F01)),
          ),
        );

        final provider = context.read<PetProfileProvider>();
        final success = await provider.updatePetImage(petId, image);
        
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('프로필 이미지가 업데이트되었습니다.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지 업데이트에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      Navigator.pop(context); // 로딩 다이얼로그 닫기
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 선택 중 오류가 발생했습니다.')),
      );
    }
  }
}

// 정보 섹션 위젯
class _InfoSection extends StatelessWidget {
  final Map<String, dynamic> detail;
  final VoidCallback onEdit;
  
  const _InfoSection({required this.detail, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final name = detail['name'] ?? '';
    final birthday = detail['birthday'] ?? '';
    final gender = _formatGender(detail['gender']);
    final species = _formatSpecies(detail['species']);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '반려동물 정보',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C5C5C),
              ),
            ),
            _EditButton(onTap: onEdit),
          ],
        ),
        const SizedBox(height: 15),
        const Divider(color: Color(0xFFF0F0F0)),
        const SizedBox(height: 20),
        _InfoItem(label: '이름', value: name),
        if (birthday.isNotEmpty) _InfoItem(label: '생년월일', value: birthday),
        if (gender.isNotEmpty) _InfoItem(label: '성별', value: gender),
        if (species.isNotEmpty) _InfoItem(label: '종', value: species),
      ],
    );
  }

  String _formatGender(dynamic gender) {
    if (gender == 'M') return '수컷';
    if (gender == 'F') return '암컷';
    return '';
  }

  String _formatSpecies(dynamic species) {
    if (species == 'DOG') return '개';
    if (species == 'CAT') return '고양이';
    return species?.toString() ?? '';
  }
}

// 성격 섹션 위젯
class _PersonalitySection extends StatelessWidget {
  final Map<String, dynamic> detail;
  final VoidCallback onEdit;
  
  const _PersonalitySection({required this.detail, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final personalities = List<String>.from(detail['personalities'] ?? []);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '성격',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5C5C5C),
              ),
            ),
            _EditButton(onTap: onEdit),
          ],
        ),
        const SizedBox(height: 15),
        if (personalities.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              '아직 등록된 성격이 없습니다',
              style: TextStyle(fontSize: 14, color: Color(0xFF9A9A9A)),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: personalities.map((p) => _PersonalityChip(label: p)).toList(),
          ),
      ],
    );
  }
}

// 개선된 삭제 다이얼로그
class _DeleteConfirmDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _DeleteConfirmDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '반려동물 삭제',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF484848),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '반려동물을 정말 삭제하시겠습니까?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9A9A9A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7E7E7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF5C5C5C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5F01),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '삭제',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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

// 수정된 _handleDelete 메서드
void _handleDelete(BuildContext context, int? petId) {
  if (petId == null) return;

  showDialog(
    context: context,
    builder: (ctx) => _DeleteConfirmDialog(
      onConfirm: () async {
        // 로딩 표시
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF5F01)),
          ),
        );

        final provider = context.read<PetProfileProvider>();
        final success = await provider.deletePet(petId);
        
        Navigator.pop(context); // 로딩 다이얼로그 닫기
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('반려동물이 삭제되었습니다.')),
          );
          Navigator.pop(context, true); // 이전 화면으로 돌아가기
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('삭제에 실패했습니다.')),
          );
        }
      },
    ),
  );
}

// 공통 컴포넌트들
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7B7B7B),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF9A9A9A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback onTap;
  
  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFCDCDCD),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          '수정',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _PersonalityChip extends StatelessWidget {
  final String label;
  
  const _PersonalityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF7C7C7C),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;
  
  const _DeleteButton({required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEDEDED),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          '프로필 삭제',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9A9A9A),
          ),
        ),
      ),
    );
  }
}