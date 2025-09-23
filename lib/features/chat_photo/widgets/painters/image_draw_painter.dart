
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../models/drawing_path_model.dart';

class ImageDrawingPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final List<DrawingPathModel> drawingPaths;
  
  ImageDrawingPainter({
    this.backgroundImage,
    required this.drawingPaths,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // 1. 배경 이미지 그리기
    if (backgroundImage != null) {
      final srcRect = Rect.fromLTWH(0, 0, 
          backgroundImage!.width.toDouble(), 
          backgroundImage!.height.toDouble());
      final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);
      canvas.drawImageRect(backgroundImage!, srcRect, dstRect, Paint());
    }
    
    // 2. 그리기 경로들 그리기
    for (final drawingPath in drawingPaths) {
      canvas.drawPath(drawingPath.path, drawingPath.paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
