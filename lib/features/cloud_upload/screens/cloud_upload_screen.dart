import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/features/chat_photo/providers/photo_screen_provider.dart';
import 'package:daenglog_fe/features/chat_photo/services/photo_service.dart';
import 'package:daenglog_fe/shared/widgets/daeng_toast.dart';
import 'package:daenglog_fe/api/diary/post/diary_save_api.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';

class CloudUploadScreen extends StatefulWidget {
  const CloudUploadScreen({super.key});

  @override
  State<CloudUploadScreen> createState() => _CloudUploadScreenState();
}

class _CloudUploadScreenState extends State<CloudUploadScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 바로 저장 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveDiary();
    });
  }

  Future<void> _saveDiary() async {
    final profile = context.read<DefaultProfileProvider>().profile;
    if (profile?.id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('반려동물을 선택해주세요')),
        );
        context.go('/home');
      }
      return;
    }

    final photoProvider = context.read<PhotoScreenProvider>();
    if (photoProvider.capturedImageBytes == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 먼저 확정해주세요')),
        );
        context.go('/home');
      }
      return;
    }

    // DiaryGptResponse에서 데이터 가져오기 (extra로 전달받은 데이터)
    final gptResponse = GoRouterState.of(context).extra as DiaryGptResponse?;
    if (gptResponse == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일기 데이터를 찾을 수 없습니다')),
        );
        context.go('/home');
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await DiarySaveApi().saveDiary(
        title: gptResponse.title,
        content: gptResponse.content,
        keyword: gptResponse.keyword,
        petId: profile!.id!,
        imageBytes: photoProvider.capturedImageBytes!,
      );

      if (mounted) {
        // 1) 갤러리에 이미지 저장 시도
        await PhotoService.saveImageToGallery(
            photoProvider.capturedImageBytes!, context);

        // 2) 알림 메시지 (갤러리 저장 성공/실패 여부와 상관없이 일기 저장 완료 안내)
        showDaengToast(
          context,
          '일기가 저장되었습니다! (${result.recordNumber}번째 기록)',
        );

        // 3) 홈으로 돌아가기
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        showDaengToast(
          context,
          '일기 저장 실패: $e',
          isWarning: true,
        );
        // 에러 발생 시에도 홈으로 돌아가기
        context.go('/home');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<DefaultProfileProvider>().profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        title: const Text(
          '일기 저장',
          style: TextStyle(
            color: Color(0xFF272727),
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 반려동물 정보 표시
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFF5F01), width: 1),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: profile?.imagePath != null
                        ? NetworkImage(profile!.imagePath!)
                        : const AssetImage(
                                'assets/images/home/default_profile.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile?.petName ?? '반려동물'}의 일기를 저장하고 있어요',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF272727),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '잠시만 기다려주세요...',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 로딩 인디케이터
            _isLoading
                ? const CircularProgressIndicator(
                    color: Color(0xFFFF5F01),
                    strokeWidth: 3,
                  )
                : const Icon(
                    Icons.check_circle,
                    color: Color(0xFFFF5F01),
                    size: 36,
                  ),

            const SizedBox(height: 24),

            // 로딩/완료 메시지
            Text(
              _isLoading ? '일기를 저장하고 있습니다...' : '처리가 완료되었습니다.',
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
