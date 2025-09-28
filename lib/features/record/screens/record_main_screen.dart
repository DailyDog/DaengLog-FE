import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/album_widget.dart';
import '../widgets/memory_widget.dart';
import '../providers/record_provider.dart';
import '../widgets/media_selection_modal.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:go_router/go_router.dart';

class RecordMainScreen extends StatelessWidget {
  const RecordMainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final profile = context.read<DefaultProfileProvider>().profile;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      
      // Media selection modal
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Top header
                Container(
                  height: 58,
                  color: const Color(0xFFFF5F01),
                  child: Row(
                    children: [
                      // Back button
                        IconButton(
                        onPressed: () => context.go('/home'),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
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
                      
                      // Right side icons
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.read<RecordProvider>().showModal();
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<RecordProvider>().showModal();
                            },
                            icon: const Icon(
                              Icons.cloud_outlined,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Pet info section
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
                                Text(
                                  '${profile?.petName}',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFF5F01),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const SizedBox(width: 8),
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
                                  '${profile?.petDaysSinceFirstDiary}일',
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
                              ],
                            ),
                          ),
                        ),
                        
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
          ),
          
          // Media selection modal
          Consumer<RecordProvider>(
            builder: (context, recordProvider, child) {
              if (!recordProvider.isModalVisible) return const SizedBox.shrink();
              
              return MediaSelectionModal(
              onGalleryTap: () => recordProvider.pickImageFromGallery(context),
              onCameraTap: () => recordProvider.takePhotoWithCamera(context),
              onClose: recordProvider.hideModal,
            );
            },
          ),
        ],
      ),
    );
  }
}
