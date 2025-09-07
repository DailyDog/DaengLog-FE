import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/get/pet_detail_api.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';

class PetDetailScreen extends StatefulWidget {
  const PetDetailScreen({super.key});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  Map<String, dynamic>? _detail;
  bool _loading = true;
  String? _error;
  dynamic _pickedImage; // XFile or similar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final petId = args?['id'] as int?;
    _fetchDetail(petId, fallbackArgs: args);
  }

  Future<void> _fetchDetail(int? petId, {Map<String, dynamic>? fallbackArgs}) async {
    setState(() { _loading = true; _error = null; });
    try {
      if (petId != null) {
        _detail = await PetDetailApi().getPetDetail(petId);
      } else {
        _detail = fallbackArgs; // 최소한 전달된 args로 표시
      }
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('불러오기 실패'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        _buildProfileSection(context),
                        SizedBox(height: screenHeight * 0.03),
                        _buildPetInfoSection(context),
                        SizedBox(height: screenHeight * 0.03),
                        _buildPersonalitySection(context),
                        SizedBox(height: screenHeight * 0.05),
                        Container(width: double.infinity, height: 1, color: const Color(0xFFEFEFEF)),
                        SizedBox(height: screenHeight * 0.03),
                        _buildDeleteButton(context),
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
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _detail?['name'] != null ? (_detail!['name'] as String) : '반려동물 상세',
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
    final String name = (_detail?['name'] as String?) ?? '';
    final String? image = _sanitizeImageUrl(_detail?['profileImageUrl'] as String?);
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: screenWidth * 0.18,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: (image != null && image.isNotEmpty)
                    ? Image.network(
                        image,
                        width: screenWidth * 0.36,
                        height: screenWidth * 0.36,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          final providerImg = _providerImagePath(context);
                          if (providerImg != null && providerImg.isNotEmpty) {
                            return Image.network(
                              providerImg,
                              width: screenWidth * 0.36,
                              height: screenWidth * 0.36,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/home/default_profile.png',
                                width: screenWidth * 0.36,
                                height: screenWidth * 0.36,
                                fit: BoxFit.cover,
                              ),
                            );
                          }
                          return Image.asset(
                            'assets/images/home/default_profile.png',
                            width: screenWidth * 0.36,
                            height: screenWidth * 0.36,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/home/default_profile.png',
                        width: screenWidth * 0.36,
                        height: screenWidth * 0.36,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: -screenWidth * 0.02,
              right: -screenWidth * 0.02,
              child: GestureDetector(
                onTap: _onChangeProfileImage,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.022),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F01),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0,2)),
                    ],
                  ),
                  child: Icon(Icons.photo_camera, color: Colors.white, size: screenWidth * 0.055),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Text(
          name,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF484848),
          ),
        ),
      ],
    );
  }

  // 회원정보 섹션
  Widget _buildMemberInfoSection(BuildContext context) {
    // deprecated in new layout
    return const SizedBox.shrink();
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

  // 반려동물 정보 섹션
  Widget _buildPetInfoSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final name = (_detail?['name'] as String?) ?? '';
    final birthday = (_detail?['birthday'] as String?) ?? '';
    final genderRaw = (_detail?['gender'] as String?) ?? '';
    final gender = genderRaw == 'M' ? '수컷' : genderRaw == 'F' ? '암컷' : '';
    final speciesRaw = (_detail?['species'] as String?) ?? '';
    final species = speciesRaw == 'DOG' ? '개' : speciesRaw == 'CAT' ? '고양이' : speciesRaw;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '반려동물 정보',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5C5C5C),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/pet_basic_edit',
                  arguments: {
                    'id': _detail?['id'],
                    'name': _detail?['name'],
                    'birthday': _detail?['birthday'],
                    'gender': _detail?['gender'],
                    'species': _detail?['species'],
                    'personalities': _detail?['personalities'] ?? [],
                  },
                ).then((changed) {
                  if (changed == true) {
                    final id = _detail?['id'] as int?;
                    _fetchDetail(id);
                  }
                });
              },
              child: _buildSmallEditPill(context),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Container(height: 1, color: const Color(0xFFF0F0F0)),
        SizedBox(height: screenHeight * 0.02),
        _buildInfoItem(context, '이름', name),
        if (birthday.isNotEmpty) _buildInfoItem(context, '생년월일', birthday),
        if (gender.isNotEmpty) _buildInfoItem(context, '성별', gender),
        if (species.isNotEmpty) _buildInfoItem(context, '종', species),
      ],
    );
  }

  // 성격 섹션
  Widget _buildPersonalitySection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final personalities = ((_detail?['personalities'] as List?)?.cast<String>()) ?? const <String>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '성격',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF5C5C5C),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/pet_personality_edit',
                  arguments: {
                    'id': _detail?['id'],
                    'name': _detail?['name'],
                    'birthday': _detail?['birthday'],
                    'gender': _detail?['gender'],
                    'species': _detail?['species'],
                    'personalities': _detail?['personalities'] ?? [],
                  },
                ).then((changed) {
                  if (changed == true) {
                    final id = _detail?['id'] as int?;
                    _fetchDetail(id);
                  }
                });
              },
              child: _buildSmallEditPill(context),
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.015),
        Wrap(
          spacing: screenWidth * 0.02,
          runSpacing: screenHeight * 0.012,
          children: personalities
              .map((p) => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: const Color(0xFF7C7C7C),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // 작은 수정 Pill
  Widget _buildSmallEditPill(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.006,
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
    );
  }

  Future<void> _onChangeProfileImage() async {
    // TODO: integrate with your existing image picker flow if available
    // For now, just navigate to an image picker route or trigger a provider method
    // Navigator.pushNamed(context, '/image_picker', arguments: {...});
  }

  String? _providerImagePath(BuildContext context) {
    try {
      return context.read<DefaultProfileProvider>().imagePath;
    } catch (_) {
      return null;
    }
  }

  // 하단 삭제 버튼
  Widget _buildDeleteButton(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        '프로필 삭제',
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF9A9A9A),
        ),
      ),
    );
  }

  String? _sanitizeImageUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    try {
      final encodedMarker = '%3F';
      final idxEncoded = url.indexOf(encodedMarker);
      final idxQuery = url.lastIndexOf('?');
      if (idxEncoded != -1 && idxQuery != -1 && idxQuery > idxEncoded) {
        final base = url.substring(0, idxEncoded);
        final query = url.substring(idxQuery);
        return base + query;
      }
      return url;
    } catch (_) {
      return url;
    }
  }

  Widget _buildSettingsSection(BuildContext context) {
    // deprecated in new layout
    return const SizedBox.shrink();
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

  Widget _buildBottomButtons(BuildContext context) {
    // deprecated in new layout
    return const SizedBox.shrink();
  }
}
