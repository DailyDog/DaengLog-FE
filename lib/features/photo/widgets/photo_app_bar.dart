import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/utils/secure_token_storage.dart';
import 'package:daenglog_fe/shared/widgets/login_modal.dart';
import 'package:daenglog_fe/features/family_share/screens/family_share_share.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/features/photo/services/photo_service.dart';

class PhotoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDecorateMode;
  final VoidCallback onSave;
  final VoidCallback onDownload;
  final DiaryGptResponse gptResponse;

  const PhotoAppBar({
    super.key,
    required this.isDecorateMode,
    required this.onSave,
    required this.onDownload,
    required this.gptResponse,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFFF6600)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('', style: TextStyle(fontFamily: 'Pretendard-Bold', color: Color(0xFF272727))),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: isDecorateMode
              ? IconButton(
                  icon: const Icon(Icons.save, color: Color(0xFFFF6600)),
                  onPressed: onSave,
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/chat/send_icon.png',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () async {
                        // 공유하기 버튼 토큰 체크
                        final token = await SecureTokenStorage.getToken();
                        if (token != null && token.isNotEmpty) {
                          // 바텀 시트로 가족 공유 화면 표시
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FamilyShareScreen(
                              sharedContent: gptResponse.content,
                              sharedImagePath: gptResponse.imageUrl,
                            ),
                          );
                        } else {
                          await showLoginModal(context);
                        }
                      },
                    ),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/chat/download_icon.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () async {
                        // 다운로드 버튼 토큰 체크
                        final token = await SecureTokenStorage.getToken();
                        if (token != null && token.isNotEmpty) {
                          onDownload();
                        } else {
                          await showLoginModal(context);
                        }
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 