import 'package:flutter/material.dart';
import 'dart:math' as math;

// 그리기 포인트 모델
class DrawPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;
  DrawPoint(this.offset, this.color, this.strokeWidth);
}

// 그림 그리기 페인터
class DrawingPainter extends CustomPainter {
  final List<DrawPoint?> points;
  final double width, height;
  DrawingPainter(this.points, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        // 지우개 모드일 때는 투명한 색상이므로 그리지 않음
        if (points[i]!.color == Colors.transparent) {
          continue;
        }
        
        final p1 = Offset(points[i]!.offset.dx * width, points[i]!.offset.dy * height);
        final p2 = Offset(points[i + 1]!.offset.dx * width, points[i + 1]!.offset.dy * height);
        final paint = Paint()
          ..color = points[i]!.color
          ..strokeWidth = points[i]!.strokeWidth
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(p1, p2, paint);
      }
    }
  }
  
  @override
  bool shouldRepaint(DrawingPainter old) => old.points != points || old.width != width || old.height != height;
}