import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';
import 'dart:io';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({Key? key}) : super(key: key);

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late Map<String, dynamic> detail;
  bool isLoading = false;
  bool isImageUploading = false; // 이미지 업로드 상태
  File? _selectedImage;
  bool _hasTriedRefresh = false;
  bool _isDataLoaded = false; // 데이터 로드 상태

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // arguments에서 petData 추출
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      detail = arguments;
      _isDataLoaded = true;
    } else {
      // Provider에서 기본 펫 데이터 가져오기
      final provider = context.read<PetProfileProvider>();
      final defaultPet = provider.defaultPet;

      if (defaultPet != null) {
        detail = {
          'id': defaultPet.id,
          'name': defaultPet.name,
          'species': defaultPet.species ?? 'DOG',
          'gender': defaultPet.gender ?? 'M',
          'birthday': defaultPet.birthday ?? '',
          'personalities': defaultPet.personalities ?? [],
          'imageUrl': defaultPet.profileImageUrl,
        };
        _isDataLoaded = true;
      } else {
        // 데이터가 없을 때만 로딩 표시
        detail = {};
        _isDataLoaded = false;
      }
    }

    // 상세 정보 로드 (백그라운드에서)
    if (_isDataLoaded) {
      _loadPetDetailInBackground();
    } else {
      _loadPetDetail();
    }
  }

  Future<void> _loadPetDetail() async {
    final provider = context.read<PetProfileProvider>();
    final petDetail = await provider.loadPetDetail(detail['id'] ?? 1);

    if (petDetail != null && mounted) {
      setState(() {
        detail = petDetail;
        _isDataLoaded = true;
      });
    }
  }

  Future<void> _loadPetDetailInBackground() async {
    final provider = context.read<PetProfileProvider>();
    final petDetail = await provider.loadPetDetail(detail['id']);

    if (petDetail != null && mounted) {
      setState(() {
        // 기존 데이터에 새 데이터 병합 (깜빡임 방지)
        detail = {
          ...detail,
          ...petDetail,
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 데이터가 로드되지 않았으면 로딩 화면
    if (!_isDataLoaded) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFF5F01),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            '내 정보 관리',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Pretendard',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFFF5F01),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '내 정보 관리',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pretendard',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 프로필 섹션
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                child: Column(
                  children: [
                    // 프로필 이미지
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFF5F01),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: _buildProfileImage(),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: isImageUploading
                                ? null
                                : _showImagePicker, // 업로드 중에는 비활성화
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isImageUploading
                                    ? Colors.grey
                                    : Colors.blue[300],
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: isImageUploading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 펫 이름
                    Text(
                      detail['name'] ?? '로딩 중...',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),

              // 반려동물 정보 섹션
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 섹션 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '반려동물 정보',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                            color: Color(0xFF333333),
                          ),
                        ),
                        GestureDetector(
                          onTap: _editBasicInfo,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '수정',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // 정보 항목들
                    _buildInfoRow('이름', detail['name'] ?? ''),
                    _buildInfoRow('생년월일', detail['birthday'] ?? ''),
                    _buildInfoRow('성별', _getGenderText(detail['gender'] ?? '')),
                  ],
                ),
              ),

              // 성격 섹션
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 섹션 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '성격',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Pretendard',
                            color: Color(0xFF333333),
                          ),
                        ),
                        GestureDetector(
                          onTap: _editPersonality,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '수정',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // 성격 태그들
                    _buildPersonalityTags(),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // 프로필 삭제 버튼
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: TextButton(
                  onPressed: _showDeleteModal,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '프로필삭제',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),

              // 아이폰16 하단 여백 확보 (픽셀 오류 해결)
              SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: 114,
        height: 114,
      );
    }

    final imageUrl = detail['imageUrl'] ?? detail['profileImageUrl'];
    print('이미지 URL: $imageUrl');

    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return Image.network(
        imageUrl.toString(),
        fit: BoxFit.cover,
        width: 114,
        height: 114,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            width: 114,
            height: 114,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF5F01),
                strokeWidth: 2,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('이미지 로드 에러: $error');
          // 한 번만 새로고침 시도
          if (!_hasTriedRefresh) {
            _hasTriedRefresh = true;
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) _refreshImageUrl();
            });
          }
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.pets, size: 60, color: Colors.grey),
          );
        },
      );
    }

    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.pets, size: 60, color: Colors.grey),
    );
  }

  Widget _buildPersonalityTags() {
    final personalities = detail['personalities'] as List<dynamic>? ?? [];

    if (personalities.isEmpty) {
      return const Text(
        '설정된 성격이 없습니다.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: personalities
          .map<Widget>((personality) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  personality.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGenderText(String gender) {
    switch (gender.toUpperCase()) {
      case 'M':
        return '수컷';
      case 'F':
        return '암컷';
      default:
        return '미상';
    }
  }

  Future<void> _refreshImageUrl() async {
    final provider = context.read<PetProfileProvider>();
    final newImageUrl = await provider.refreshPetImageUrl(detail['id']);

    if (newImageUrl != null && mounted) {
      setState(() {
        detail['imageUrl'] = newImageUrl;
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 180,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('카메라로 촬영'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('갤러리에서 선택'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    if (isImageUploading) return; // 업로드 중이면 리턴

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        await _updatePetImage(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미지 선택 중 오류가 발생했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updatePetImage(XFile imageFile) async {
    if (isImageUploading) return; // 이미 업로드 중이면 리턴

    setState(() {
      isImageUploading = true;
    });

    try {
      final provider = context.read<PetProfileProvider>();
      final success = await provider.updatePetImage(detail['id'], imageFile);

      if (mounted) {
        setState(() {
          isImageUploading = false;
        });

        if (success) {
          // Provider에서 업데이트된 이미지 URL 가져오기
          final updatedImageUrl = provider.getPetImage(detail['id']);
          setState(() {
            detail['imageUrl'] = updatedImageUrl;
            _selectedImage = null; // 업로드 완료 후 로컬 이미지 제거
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('프로필 이미지가 업데이트되었습니다.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          setState(() {
            _selectedImage = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('서버 오류로 이미지 업데이트에 실패했습니다. 잠시 후 다시 시도해주세요.'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isImageUploading = false;
          _selectedImage = null;
        });

        print('이미지 업데이트 에러: $e');

        String errorMessage = '이미지 업데이트에 실패했습니다.';
        if (e.toString().contains('500')) {
          errorMessage = '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.';
        } else if (e.toString().contains('network')) {
          errorMessage = '네트워크 연결을 확인해주세요.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _editBasicInfo() {
    Navigator.pushNamed(
      context,
      '/pet_basic_edit',
      arguments: detail,
    ).then((result) {
      if (result == true) {
        _loadPetDetailInBackground(); // 수정 후 상세 정보 다시 로드
      }
    });
  }

  void _editPersonality() {
    Navigator.pushNamed(
      context,
      '/pet_personality_edit',
      arguments: detail,
    ).then((result) {
      if (result == true) {
        _loadPetDetailInBackground(); // 수정 후 상세 정보 다시 로드
      }
    });
  }

  void _showDeleteModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '반려동물 삭제',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '반려동물을 정말 삭제하시겠습니까?\n삭제된 정보는 복구할 수 없습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '취소',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteProfile();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFFFF5F01),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '삭제',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final provider = context.read<PetProfileProvider>();
      final success = await provider.deletePet(detail['id']);

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${detail['name']}의 정보가 삭제되었습니다.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.pop(context, {'deleted': true, 'petId': detail['id']});
        } else {
          throw Exception('삭제에 실패했습니다.');
        }
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });

        print('펫 삭제 에러: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('삭제 중 오류가 발생했습니다: ${error.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
