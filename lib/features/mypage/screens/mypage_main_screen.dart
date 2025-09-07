import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_edit_modal.dart';
import 'package:daenglog_fe/api/pets/models/pets_info.dart';
import 'package:daenglog_fe/api/mypage/get/my_page_summary_api.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';
import 'package:daenglog_fe/api/mypage/get/pet_simple_list_api.dart';
import 'package:daenglog_fe/api/mypage/models/pet_simple_item.dart';
import 'package:daenglog_fe/api/mypage/post/pet_set_default_api.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/features/mypage/widgets/top_section.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_horizontal_list.dart';
import 'package:daenglog_fe/shared/utils/image_utils.dart';
import 'package:daenglog_fe/features/mypage/widgets/menu_item.dart';
import 'package:daenglog_fe/features/mypage/widgets/bottom_section.dart';
import 'package:daenglog_fe/api/mypage/get/pet_all_api.dart';
import 'package:daenglog_fe/api/mypage/models/pet_all_item.dart';

class MyPageMainScreen extends StatefulWidget {
  const MyPageMainScreen({super.key});

  @override
  State<MyPageMainScreen> createState() => _MyPageMainScreenState();
}

class _MyPageMainScreenState extends State<MyPageMainScreen> {
  bool _showPetEditModal = false;
  MyPageSummary? _summary;
  bool _loadingSummary = true;
  String? _summaryError;
  // 전체 펫 이미지 캐시 (id -> url)
  final Map<int, String?> _allPetImages = {};
  bool _loadingAllPets = false;

  // 모달용 간단 리스트 캐시
  List<PetSimpleItem> _simplePets = [];
  bool _loadingSimplePets = false;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
    _fetchAllPets();
  } 

  Future<void> _fetchSummary() async {
    setState(() {
      _loadingSummary = true;
      _summaryError = null;
    });
    try {
      final api = MyPageSummaryApi();
      final result = await api.getSummary();
      setState(() {
        _summary = result;
      });
    } catch (e) {
      setState(() {
        _summaryError = '$e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingSummary = false;
        });
      }
    }
  }

  Future<void> _fetchAllPets() async {
    setState(() { _loadingAllPets = true; });
    try {
      final list = await PetAllApi().getAll();
      for (final item in list) {
        _allPetImages[item.id] = _sanitizeImageUrl(item.profileImageUrl);
      }
    } catch (_) {
      // ignore; fallback to per-item urls
    } finally {
      if (mounted) setState(() { _loadingAllPets = false; });
    }
  }

  Future<void> _openPetEditModal() async {
    setState(() {
      _loadingSimplePets = true;
    });
    try {
      final api = PetSimpleListApi();
      final list = await api.getMySimpleList();
      setState(() {
        _simplePets = list;
        _showPetEditModal = true;
      });
    } catch (_) {
      // 간단히 모달을 열지 않음
    } finally {
      if (mounted) {
        setState(() {
          _loadingSimplePets = false;
        });
      }
    }
  }

  // 요약 데이터에서 대표 반려동물을 맨 앞으로 정렬
  List<PetSummary> _orderedMyPets() {
    final list = List<PetSummary>.from(_summary?.myPets ?? const []);
    if (_summary == null) return list;
    list.sort((a, b) {
      final aIsDefault = a.id == _summary!.defaultPet.id;
      final bIsDefault = b.id == _summary!.defaultPet.id;
      if (aIsDefault == bIsDefault) return 0;
      return aIsDefault ? -1 : 1;
    });
    return list;
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

  String? _imageForPetId(BuildContext context, int petId, String? fallbackUrl) {
    try {
      final provider = Provider.of<DefaultProfileProvider>(context, listen: false);
      final providerId = provider.petId;
      final providerPath = provider.imagePath;
      if (providerId != null && providerId == petId && providerPath != null && providerPath.isNotEmpty) {
        return providerPath;
      }
    } catch (_) {}
    return _allPetImages[petId] ?? _sanitizeImageUrl(fallbackUrl);
  }

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
              // 프로필 섹션 (분리 위젯)
              MyPageTopSection(
                summary: _summary,
                loading: _loadingSummary,
                imageUrl: _imageForPetId(
                  context,
                  _summary?.defaultPet.id ?? (Provider.of<DefaultProfileProvider>(context, listen: false).petId ?? -1),
                  _summary?.defaultPet.profileImageUrl,
                ),
              ),
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
                  child: MyPageBottomSection(
                    pets: _orderedMyPets()
                        .map((p) => PetListItem(
                              id: p.id,
                              name: p.name,
                              imageUrl: _imageForPetId(context, p.id, p.profileImageUrl),
                            ))
                        .toList(),
                    selectedPetId: _summary?.defaultPet.id,
                    onEditPets: _openPetEditModal,
                  ),
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
              pets: _simplePets
                  .map((p) => PetInfo(
                        name: p.name,
                        age: '${p.age}살',
                        isRepresentative: p.isDefault,
                        imageUrl: _imageForPetId(context, p.id, p.profileImageUrl),
                      ))
                  .toList(),
              showAddFamilyPet: (_summary?.planCode ?? '') == 'FAMILY',
              resolvePetId: (i) => _simplePets[i].id,
              onSetDefault: (i, pet) async {
                final id = _simplePets[i].id;
                await PetSetDefaultApi().setDefault(id);
                try {
                  await Provider.of<DefaultProfileProvider>(context, listen: false).fetchProfile();
                } catch (_) {}
                await _fetchSummary();
              },
              onAddPet: () {
                // 페이지 이동으로 연결 (예: 반려동물 등록 플로우)
                // Navigator.pushNamed(context, '/pet_add');
              },
              onSelectPet: (pet, index) async {
                if (_summary == null) return;
                try {
                  // simple 리스트 기준으로 id 조회
                  final match = _simplePets[index];
                  await PetSetDefaultApi().setDefault(match.id);
                  try {
                    await Provider.of<DefaultProfileProvider>(context, listen: false).fetchProfile();
                  } catch (_) {}
                  await _fetchSummary();
                } catch (_) {
                  // 나중에 스낵바/토스트로 안내
                }
              },
              isFamilyShared: (pet) {
                final match = _simplePets.firstWhere(
                  (p) => p.name == pet.name,
                  orElse: () => _simplePets.first,
                );
                return match.isFamilyPet;
              },
              onEditPet: (pet) {
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
              Consumer<DefaultProfileProvider>(
                builder: (context, defaultProfile, _) {
                  final summaryPath = _sanitizeImageUrl(_summary?.defaultPet.profileImageUrl);
                  final providerPath = defaultProfile.imagePath;
                  final displayUrl = (summaryPath != null && summaryPath.isNotEmpty)
                      ? summaryPath
                      : ((providerPath != null && providerPath.isNotEmpty) ? providerPath : null);
                  return CircleAvatar(
                    radius: screenWidth * 0.16,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: (displayUrl != null)
                          ? Image.network(
                              displayUrl,
                              width: screenWidth * 0.32,
                              height: screenWidth * 0.32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                'assets/images/home/default_profile.png',
                                width: screenWidth * 0.32,
                                height: screenWidth * 0.32,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/home/default_profile.png',
                              width: screenWidth * 0.32,
                              height: screenWidth * 0.32,
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                },
              ),
              
              SizedBox(width: screenWidth * 0.05), // 간격
              
              // 텍스트 부분을 Column으로 배치
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _loadingSummary
                          ? '...'
                          : '${_summary?.defaultPet.name ?? ''} 집사님,\n안녕하세요!',
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
                        '${_summary?.planName ?? ''} 플랜',
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
          // 반려동물 섹션 (분리 위젯)
          PetHorizontalList(
            pets: _orderedMyPets()
                .map((p) => PetListItem(id: p.id, name: p.name, imageUrl: _sanitizeImageUrl(p.profileImageUrl)))
                .toList(),
            selectedPetId: _summary?.defaultPet.id,
            onEditTap: _openPetEditModal,
          ),
          
          SizedBox(height: screenHeight * 0.02),
          Container(
            height: 1,
            color: const Color(0xFFE7E7E7),
          ),
          SizedBox(height: screenHeight * 0.02),
          
          
          SizedBox(height: screenHeight * 0.01),
          
          // 메뉴 아이템
          _buildMenuItem(context, '내정보 관리', Icons.person_outline, '/my_info_page'),
          _buildMenuItem(context, '이벤트/혜택', Icons.card_giftcard, '/event'),
          _buildMenuItem(context, '요금제 관리', Icons.payment, '/cloud_main'),
          _buildMenuItem(context, '공지사항', Icons.announcement, '/notice'),
          _buildMenuItem(context, '고객센터', Icons.help_outline, '/customer_center'),

          SizedBox(height: screenHeight * 0.02),
          Container(
            height: 1,
            color: const Color(0xFFE7E7E7),
          ),
          SizedBox(height: screenHeight * 0.02),
          
          // 로그아웃 버튼
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.01,
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

          SizedBox(height: screenHeight * 0.006),
          
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

  // 내 반려동물 카드 (Deprecated by PetHorizontalList)
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

  // 내 반려동물 카드(이미지) (Deprecated by PetHorizontalList)
  Widget _buildPetCardWithImage(BuildContext context, {required String name, required bool isSelected, String? imageUrl}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: screenWidth * 0.15,
          height: screenWidth * 0.15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFFFF5F01) : Colors.grey[400]!,
              width: screenWidth * 0.005,
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

  // 메뉴 아이템 (Deprecated by MyPageMenuItem)
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