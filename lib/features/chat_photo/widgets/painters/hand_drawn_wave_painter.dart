import 'dart:math' as math;
import 'package:flutter/material.dart';

// 그림 그리기 오버레이
class HandDrawnWave extends StatelessWidget {
  const HandDrawnWave({
    super.key,
    this.color = const Color(0xFFFF6600),
    this.strokeWidth = 4,
    this.amplitude = 4,
    this.segment = 20,     // 구간 길이(px) – 작을수록 더 잔잔
    this.jitter = 1.2,     // 무작위 변위 세기
  });

  final Color  color;
  final double strokeWidth;
  final double amplitude;
  final double segment;
  final double jitter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HandDrawnPainter(
        color: color,
        strokeWidth: strokeWidth,
        amplitude: amplitude,
        segment: segment,
        jitter: jitter,
      ),
    );
  }
}

class _HandDrawnPainter extends CustomPainter {
  _HandDrawnPainter({
    required this.color,
    required this.strokeWidth,
    required this.amplitude,
    required this.segment,
    required this.jitter,
  });

  final Color  color;
  final double strokeWidth;
  final double amplitude;
  final double segment;
  final double jitter;
  final _rand = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..strokeWidth = strokeWidth
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, size.height * .5);

    // 한 구간씩 Bezier 곡선으로 연결
    for (double x = 0; x < size.width; x += segment) {
      final xCtrl  = x + segment / 2;
      final yCtrl  = size.height * .5 +
          _rand.nextDouble() * amplitude * ( _rand.nextBool() ? 1 : -1);
      final xEnd   = math.min(x + segment, size.width);
      final yEnd   = size.height * .5 +
          (_rand.nextDouble() - .5) * 2 * amplitude * jitter;

      path.quadraticBezierTo(xCtrl, yCtrl, xEnd, yEnd);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HandDrawnPainter old) => false;
}