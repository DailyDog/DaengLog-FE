import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/shared/utils/secure_token_storage.dart';
import 'package:daenglog_fe/shared/services/pet_profile_provider.dart';

class LogoutService {
  static Future<void> logout(BuildContext context) async {
    try {
      // 1. 로컬 저장소 토큰 삭제
      await SecureTokenStorage.clear();

      // 2. Provider 상태 초기화
      if (context.mounted) {
        context.read<PetProfileProvider>().clear();
        // 다른 Provider들도 있다면 여기서 초기화
      }

      // 3. 로그인 페이지로 이동 (스택 모두 제거)
      if (context.mounted) {
        context.go('/login');
      }

      print('🟢 로그아웃 완료');
    } catch (e) {
      print('🔴 로그아웃 실패: $e');
    }
  }

  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF484848),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '정말 로그아웃하시겠습니까?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9A9A9A),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E7E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5C5C5C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        logout(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5F01),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
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
}
