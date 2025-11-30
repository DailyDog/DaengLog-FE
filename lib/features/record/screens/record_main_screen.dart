import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/album_widget.dart';
import '../widgets/memory_widget.dart';
import '../providers/record_provider.dart';
import '../widgets/media_selection_modal.dart';
import '../widgets/media_selection_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class RecordMainScreen extends StatefulWidget {
  const RecordMainScreen({super.key});

  @override
  State<RecordMainScreen> createState() => _RecordMainScreenState();
}

class _RecordMainScreenState extends State<RecordMainScreen> {
  @override
  void initState() {
    super.initState();
    // 반려동물 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RecordProvider>().loadPetList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태바를 주황색으로 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFFF5F01),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFF5F01),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final recordProvider = context.watch<RecordProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 58,
        flexibleSpace: Container(
          color: const Color(0xFFFF5F01),
          child: SafeArea(
            child: Row(
              children: [
                // Left side icon (+ button)
                Container(
                  width: 58,
                  height: 58,
                  child: IconButton(
                    onPressed: () {
                      context.read<RecordProvider>().showMediaSelectionModal();
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),

                // Title
                Expanded(
                  child: Center(
                    child: Text(
                      '추억 저장소',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Right side icon (cloud)
                Container(
                  width: 58,
                  height: 58,
                  child: IconButton(
                    onPressed: () {
                      context.go('/cloud');
                    },
                    icon: const Icon(
                      Icons.cloud_outlined,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Media selection modal
      body: Stack(
        children: [
          Column(
            children: [
              // Pet info section (fixed)
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 19.2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    children: [
                      // 반려동물 드롭다운
                      GestureDetector(
                        onTap: () => _showPetDropdown(context, recordProvider),
                        child: Row(
                          children: [
                            Text(
                              recordProvider.selectedPet?.name ?? '반려동물 선택',
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFF5F01),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFFFF5F01),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (recordProvider.daysSinceFirstDiary > 0) ...[
                        Text(
                          '의 추억이 기록된 지 ',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                          ),
                        ),
                        Text(
                          '${recordProvider.daysSinceFirstDiary}일',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF5F01),
                          ),
                        ),
                        Text(
                          ' 째',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                          ),
                        ),
                      ] else ...[
                        Text(
                          '의 추억을 기록해보세요!',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF272727),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Scrollable content (calendar and below)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Calendar widget
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CalendarWidget(),
                      ),

                      // Album widget
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: AlbumWidget(),
                      ),

                      // Memory widget
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: MemoryWidget(),
                      ),

                      // Bottom padding for better scrolling
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Media selection modal
          Consumer<RecordProvider>(
            builder: (context, recordProvider, child) {
              if (!recordProvider.isModalVisible)
                return const SizedBox.shrink();

              return MediaSelectionModal(
                onGalleryTap: () =>
                    recordProvider.pickImageFromGallery(context),
                onCameraTap: () => recordProvider.takePhotoWithCamera(context),
                onClose: recordProvider.hideModal,
              );
            },
          ),

          // Media selection bottom sheet with animation
          Consumer<RecordProvider>(
            builder: (context, recordProvider, child) {
              if (!recordProvider.isMediaSelectionModalVisible)
                return const SizedBox.shrink();

              return AnimatedOpacity(
                opacity:
                    recordProvider.isMediaSelectionModalVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: GestureDetector(
                  onTap: recordProvider.hideMediaSelectionModal,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TweenAnimationBuilder<Offset>(
                        tween: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: recordProvider.isMediaSelectionModalVisible
                              ? Offset.zero
                              : const Offset(0, 1),
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        builder: (context, offset, child) {
                          return Transform.translate(
                            offset: offset * MediaQuery.of(context).size.height,
                            child: const MediaSelectionBottomSheet(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPetDropdown(BuildContext context, RecordProvider recordProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            const Text(
              '반려동물 선택',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF272727),
              ),
            ),
            const SizedBox(height: 24),

            // List
            if (recordProvider.isLoadingPets)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Color(0xFFFF5F01)),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: recordProvider.petList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final pet = recordProvider.petList[index];
                    final isSelected = recordProvider.selectedPet?.id == pet.id;
                    
                    return InkWell(
                      onTap: () {
                        recordProvider.selectPet(pet);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFF5F0) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF5F01) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: pet.profileImageUrl != null
                                  ? NetworkImage(pet.profileImageUrl!)
                                  : null,
                              child: pet.profileImageUrl == null
                                  ? Icon(Icons.pets, color: Colors.grey[400], size: 24)
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pet.name,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: const Color(0xFF272727),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${pet.age}살',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFFFF5F01),
                                size: 24,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
