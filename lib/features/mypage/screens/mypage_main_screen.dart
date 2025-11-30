import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_edit_modal.dart';
import 'package:daenglog_fe/api/mypage/get/my_page_summary_api.dart';
import 'package:daenglog_fe/api/mypage/models/my_page_summary.dart';
import 'package:daenglog_fe/api/mypage/post/pet_set_default_api.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
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
  late final DraggableScrollableController _sheetController;

  double _minExtent = 0.65;
  double _initialExtent = 0.67;
  double _maxExtent = 0.90;
  double _overlayOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _sheetController = DraggableScrollableController();
    _sheetController.addListener(_onSheetChanged);
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;

    try {
      final provider = context.read<PetProfileProvider>();

      await Future.wait([
        _loadSummary(),
        provider.loadPets(),
      ]);

      if (mounted) _debugData();
    } catch (e) {
      debugPrint('Failed to initialize: $e');
    }
  }

  void _debugData() {
    if (!mounted) return;

    try {
      final provider = context.read<PetProfileProvider>();

      print("=== 디버깅 정보 ===");
      print(
          "Summary defaultPet imageUrl: ${_summary?.defaultPet.profileImageUrl}");
      print(
          "Provider defaultPet imageUrl: ${provider.defaultPet?.profileImageUrl}");
      print("Provider allPets count: ${provider.allPets.length}");

      for (var pet in provider.allPets) {
        print("Pet ${pet.name} (${pet.id}): ${pet.profileImageUrl}");
      }
      print("==================");
    } catch (e) {
      debugPrint('Failed to debug data: $e');
    }
  }

  Future<void> _loadSummary() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      _summary = await MyPageSummaryApi().getSummary();
    } catch (e) {
      debugPrint('Failed to load summary: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSheetChanged() {
    if (!mounted) return;
    final extent = _sheetController.size;
    final progress =
        ((extent - _minExtent) / (_maxExtent - _minExtent)).clamp(0.0, 1.0);
    final opacity = 0.25 * progress;
    if (opacity != _overlayOpacity && mounted) {
      setState(() => _overlayOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetChanged);
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PetProfileProvider>();
    final screenHeight = MediaQuery.of(context).size.height;

    // 이미지 URL 우선순위 결정
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
          // 전체 배경을 SafeArea로 감싸기
          SafeArea(
            child: Column(
              children: [
                // 주황색 헤더 영역 (고정 높이)
                Container(
                  height: screenHeight * 0.25,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F01),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: MyPageTopSection(
                    summary: _summary,
                    loading: _loading,
                    imageUrl: imageUrl,
                    provider: provider,
                  ),
                ),

                // 나머지 공간은 DraggableScrollableSheet가 채움
                // Expanded(child: Container()),
              ],
            ),
          ),

          // 헤더를 덮는 딤 오버레이
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              color: Colors.black.withOpacity(_overlayOpacity),
            ),
          ),

          // DraggableScrollableSheet - SafeArea 밖에 위치
          DraggableScrollableSheet(
            controller: _sheetController,
            minChildSize: _minExtent,
            initialChildSize: _initialExtent,
            maxChildSize: _maxExtent,
            snap: true,
            snapSizes: const [0.74, 0.85],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 9),
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 88),
                          child: MyPageBottomSection(
                            pets: petListItems,
                            selectedPetId: provider.defaultPet?.id,
                            onEditPets: () => setState(() => _showModal = true),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 반려동물 편집 모달
          if (_showModal)
            _PetEditModalWrapper(
              provider: provider,
              summary: _summary,
              onClose: () => setState(() => _showModal = false),
              onUpdate: () async {
                await _initialize();
                if (mounted) setState(() => _showModal = false);
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
                id: p.id,
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
        // DefaultProfileProvider 업데이트
        await context.read<DefaultProfileProvider>().fetchProfile();
        onUpdate();
      },
      onAddPet: () {
        context.go('/pet_info');
      },
      onSelectPet: (pet, index) async {
        final petId = pets[index].id;
        await PetSetDefaultApi().setDefault(petId);
        // DefaultProfileProvider 업데이트
        await context.read<DefaultProfileProvider>().fetchProfile();
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
        context.go('/pet_detail', extra: {'id': match.id});
      },
    );
  }
}
