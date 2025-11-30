import 'package:flutter/material.dart';

/// 편지 봉투 위젯
/// 
/// 초대장을 나타내는 편지 봉투 디자인 위젯입니다.
/// Figma 디자인: 4-4-2 초대 코드 전송 (편지 봉투)
class EnvelopeWidget extends StatelessWidget {
  const EnvelopeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 편지 봉투 배경 (회전된 형태)
        Transform.rotate(
          angle: 0.39, // 약 22도 회전 (Figma: rotate-[22.312deg])
          child: Container(
            width: 313,
            height: 280,
            decoration: BoxDecoration(
              // TODO: 실제 이미지 사용 시 이미지로 교체
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // 편지 봉투 배경 그라데이션
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFFF5F01).withOpacity(0.8),
                        const Color(0xFFFFB6C1).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                
                // 하트 모양 봉투 플랩 (상단)
                Positioned(
                  top: 0,
                  left: 50,
                  right: 50,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF5F01).withOpacity(0.9),
                          const Color(0xFFFFB6C1).withOpacity(0.9),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: CustomPaint(
                      painter: HeartFlapPainter(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // 댕댕일기 로고 (봉투 안)
        Positioned(
          bottom: 80,
          child: Container(
            width: 43,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 24,
              color: Color(0xFFFF5F01),
            ),
          ),
        ),
      ],
    );
  }
}

/// 하트 모양 봉투 플랩을 그리는 커스텀 페인터
class HeartFlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final path = Path();
    // 하트 모양 플랩 그리기
    final centerX = size.width / 2;
    
    path.moveTo(centerX, size.height * 0.7);
    path.quadraticBezierTo(
      centerX - size.width * 0.2,
      size.height * 0.5,
      centerX - size.width * 0.15,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      centerX - size.width * 0.1,
      size.height * 0.1,
      centerX,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      centerX + size.width * 0.1,
      size.height * 0.1,
      centerX + size.width * 0.15,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      centerX + size.width * 0.2,
      size.height * 0.5,
      centerX,
      size.height * 0.7,
    );
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

