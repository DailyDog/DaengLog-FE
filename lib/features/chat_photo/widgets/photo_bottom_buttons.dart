import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/utils/secure_token_storage.dart';
import 'package:daenglog_fe/shared/widgets/login_modal.dart';

// 포토카드 하단 버튼
class PhotoBottomButtons extends StatelessWidget {
  final bool isConfirmed;
  final bool imageLoaded;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final VoidCallback onSharePressed;

  const PhotoBottomButtons({
    super.key,
    required this.isConfirmed,
    required this.imageLoaded,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  if (isConfirmed) {
                    // 클라우드 업로드 버튼일 때 토큰 체크
                    final token = await SecureTokenStorage.getToken();
                    if (token != null && token.isNotEmpty) {
                      // 토큰이 있으면 클라우드 업로드 페이지로 이동
                      Navigator.pushNamed(context, '/cloud_upload');
                    } else {
                      // 토큰이 없으면 로그인 페이지로 이동
                      await showLoginModal(context);
                    }
                  } else {
                    // 일기 꾸미기 버튼일 때
                    onLeftButtonPressed();
                  }
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: isConfirmed ? const Color(0xFFFF6600) : Colors.white,
                  side: const BorderSide(color: Color(0xFFFF6600)),
                  foregroundColor: isConfirmed ? Colors.white : const Color(0xFFFF6600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  isConfirmed ? '클라우드 업로드' : '일기 꾸미기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: isConfirmed ? FontWeight.w700 : FontWeight.w500,
                    fontSize: isConfirmed ? 15 : 17,
                    color: isConfirmed ? Colors.white : const Color(0xFFFF6600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: imageLoaded ? (isConfirmed ? () async {
                  // 공유하기 버튼일 때 토큰 체크
                  final token = await SecureTokenStorage.getToken();
                  if (token != null && token.isNotEmpty) {
                    // 토큰이 있으면 공유 기능 실행
                    onSharePressed();
                  } else {
                    // 토큰이 없으면 로그인 모달 표시
                    await showLoginModal(context);
                  }
                } : onRightButtonPressed) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isConfirmed ? Colors.white : const Color(0xFFFF6600),
                  foregroundColor: isConfirmed ? const Color(0xFFFF6600) : Colors.white,
                  side: isConfirmed ? const BorderSide(color: Color(0xFFFF6600)) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(
                  isConfirmed ? '공유하기' : '확정하기',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 17,
                    color: isConfirmed ? const Color(0xFFFF6600) : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 