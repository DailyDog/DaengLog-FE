import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_edit_modal.dart';
import 'package:daenglog_fe/api/mypage/get/my_page_summary_api.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';
import 'package:daenglog_fe/api/mypage/post/pet_set_default_api.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';
import 'package:daenglog_fe/features/mypage/widgets/top_section.dart';
import 'package:daenglog_fe/features/mypage/widgets/bottom_section.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_horizontal_list.dart';
import 'package:daenglog_fe/api/pets/models/pets_info.dart';

class MyPageMainScreen extends StatefulWidget {
  const MyPageMainScreen({super.key});

  @override
  State<MyPageMainScreen> createState() => _MyPageMainScreenState();
}

class _MyPageMainScreenState extends State<MyPageMainScreen> {
  MyPageSummary? _summary;
  bool _loading = true;
  bool _showModal = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final provider = context.read<PetProfileProvider>();
    
    // 병렬로 데이터 로드
    await Future.wait([
      _loadSummary(),
      provider.loadPets(),
    ]);
    
    // 🔍 디버깅: 데이터 확인
    _debugData();
  }

  void _debugData() {
    final provider = context.read<PetProfileProvider>();
    
    print("=== 디버깅 정보 ===");
    print("Summary defaultPet imageUrl: ${_summary?.defaultPet.profileImageUrl}");
    print("Provider defaultPet imageUrl: ${provider.defaultPet?.profileImageUrl}");
    print("Provider allPets count: ${provider.allPets.length}");
    
    for (var pet in provider.allPets) {
      print("Pet ${pet.name} (${pet.id}): ${pet.profileImageUrl}");
    }
    print("==================");
  }

  Future<void> _loadSummary() async {
    setState(() => _loading = true);
    try {
      _summary = await MyPageSummaryApi().getSummary();
    } catch (e) {
      debugPrint('Failed to load summary: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProfileProvider>();
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 🔍 이미지 URL 우선순위 결정
    String? imageUrl;
    if (provider.defaultPet?.profileImageUrl != null && 
        provider.defaultPet!.profileImageUrl!.isNotEmpty) {
      imageUrl = provider.defaultPet!.profileImageUrl;
      print("🟢 Using provider image: $imageUrl");
    } else if (_summary?.defaultPet.profileImageUrl != null && 
               _summary!.defaultPet.profileImageUrl!.isNotEmpty) {
      imageUrl = _summary!.defaultPet.profileImageUrl;
      print("🟡 Using summary image: $imageUrl");
    } else {
      print("🔴 No image URL available");
    }
    
    // PetListItem 리스트 생성
    final petListItems = provider.allPets
        .map((p) => PetListItem(
              id: p.id,
              name: p.name,
              imageUrl: p.profileImageUrl,
            ))
        .toList();
    
    // 대표 반려동물을 맨 앞으로 정렬
    petListItems.sort((a, b) {
      if (a.id == provider.defaultPet?.id) return -1;
      if (b.id == provider.defaultPet?.id) return 1;
      return 0;
    });
    
    return Scaffold(
      backgroundColor: const Color(0xFFFF5F01),
      body: Stack(
        children: [
          // 배경 그라데이션
          Container(
            height: screenHeight * 0.20,
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
              // 상단 프로필 섹션
              MyPageTopSection(
                summary: _summary,
                loading: _loading,
                imageUrl: provider.defaultPet?.profileImageUrl ?? _summary?.defaultPet.profileImageUrl,
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
                    pets: petListItems,
                    selectedPetId: provider.defaultPet?.id,
                    onEditPets: () => setState(() => _showModal = true),
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
            child: commonBottomNavBar(context: context, currentIndex: 3),
          ),

          // 반려동물 편집 모달
          if (_showModal)
            _PetEditModalWrapper(
              provider: provider,
              summary: _summary,
              onClose: () => setState(() => _showModal = false),
              onUpdate: () async {
                await _initialize();
                setState(() => _showModal = false);
              },
            ),
        ],
      ),
    );
  }
}

// 모달 래퍼 위젯
class _PetEditModalWrapper extends StatelessWidget {
  final PetProfileProvider provider;
  final MyPageSummary? summary;
  final VoidCallback onClose;
  final VoidCallback onUpdate;

  const _PetEditModalWrapper({
    required this.provider,
    required this.summary,
    required this.onClose,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final pets = provider.allPets;
    
    return PetEditModal(
      onClose: onClose,
      pets: pets
          .map((p) => PetInfo(
                id: p.id, // 추가
                name: p.name,
                age: '${p.age}살',
                isRepresentative: p.isDefault,
                imageUrl: p.profileImageUrl,
              ))
          .toList(),
      showAddFamilyPet: summary?.planCode == 'FAMILY',
      resolvePetId: (i) => pets[i].id,
      onSetDefault: (i, pet) async {
        final petId = pets[i].id;
        await PetSetDefaultApi().setDefault(petId);
        provider.setDefaultPet(petId);
        onUpdate();
      },
      onAddPet: () {
        Navigator.pushNamed(context, '/pet_info');
      },
      onSelectPet: (pet, index) async {
        final petId = pets[index].id;
        await PetSetDefaultApi().setDefault(petId);
        provider.setDefaultPet(petId);
      },
      isFamilyShared: (pet) {
        final match = pets.firstWhere(
          (p) => p.name == pet.name,
          orElse: () => pets.first,
        );
        return match.isFamilyPet;
      },
      onEditPet: (pet) {
        final match = pets.firstWhere(
          (p) => p.name == pet.name,
          orElse: () => pets.first,
        );
        Navigator.pushNamed(
          context,
          '/pet_detail',
          arguments: {'id': match.id},
        );
      },
    );
  }
}