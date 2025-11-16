import 'package:flutter/material.dart';

/// 앱 공통 토스트 스타일 (상단/하단 플로팅 배너)
void showDaengToast(
  BuildContext context,
  String message, {
  bool isWarning = false,
  bool top = false,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isWarning ? Icons.warning_amber_rounded : Icons.info_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black.withOpacity(0.8),
      elevation: 0,
      margin: top
          ? const EdgeInsets.fromLTRB(16, 16, 16, 0)
          : const EdgeInsets.fromLTRB(16, 0, 16, 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}


