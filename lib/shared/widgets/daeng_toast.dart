import 'package:flutter/material.dart';

/// 앱 공통 토스트 스타일 (상단/하단 플로팅 배너)
void showDaengToast(
  BuildContext context,
  String message, {
  bool isWarning = false,
  bool top = false,
}) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: const Color(0xFF333333).withOpacity(0.9),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isWarning) ...[
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
        ] else ...[
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: top ? ToastGravity.TOP : ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
    fadeDuration: const Duration(milliseconds: 200),
  );
}

// FToast class implementation (simplified for internal use if package not available, 
// but assuming fluttertoast or similar is used, or implementing custom overlay)
// Since we don't have fluttertoast in pubspec, we'll use a custom Overlay implementation.

class FToast {
  BuildContext? context;
  static final FToast _instance = FToast._internal();

  factory FToast() {
    return _instance;
  }

  FToast._internal();

  void init(BuildContext context) {
    this.context = context;
  }

  void showToast({
    required Widget child,
    required ToastGravity gravity,
    required Duration toastDuration,
    required Duration fadeDuration,
  }) {
    if (context == null) return;
    
    final overlay = Overlay.of(context!);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: gravity == ToastGravity.TOP ? MediaQuery.of(context).padding.top + 20 : null,
        bottom: gravity == ToastGravity.BOTTOM ? MediaQuery.of(context).padding.bottom + 40 : null,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: fadeDuration,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: child,
                );
              },
              child: child,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(toastDuration, () {
      overlayEntry.remove();
    });
  }
}

enum ToastGravity { TOP, BOTTOM }


