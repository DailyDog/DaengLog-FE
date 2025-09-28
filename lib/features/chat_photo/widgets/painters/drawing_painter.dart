import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/chat_photo/models/drawing_path_model.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingPathModel> paths;

  DrawingPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    for (final drawing in paths) {
      canvas.drawPath(drawing.path, drawing.paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.paths != paths;
  }
}


