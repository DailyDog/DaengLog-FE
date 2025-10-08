
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../models/drawing_path_model.dart';
import '../../models/photo_sticker_model.dart';

class ImageDrawingPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final List<DrawingPathModel> drawingPaths;
  final List<PhotoStickerModel> placedStickers;
  final int? selectedStickerIndex;
  
  ImageDrawingPainter({
    this.backgroundImage,
    required this.drawingPaths,
    this.placedStickers = const [],
    this.selectedStickerIndex,
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

    // 3. 스티커들 그리기
    for (int i = 0; i < placedStickers.length; i++) {
      final stickerModel = placedStickers[i];
      _drawSticker(canvas, stickerModel, i == selectedStickerIndex);
    }
  }

  // 스티커 그리기 헬퍼 메서드
  void _drawSticker(Canvas canvas, PhotoStickerModel stickerModel, bool isSelected) {
    canvas.save();
    
    // 위치 이동
    canvas.translate(stickerModel.position.dx, stickerModel.position.dy);
    
    // 회전
    canvas.rotate(stickerModel.rotation);
    
    // 크기 조정
    canvas.scale(stickerModel.scale);
    
    // 아이콘 그리기
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(stickerModel.sticker.icon.codePoint),
        style: TextStyle(
          fontSize: 40,
          fontFamily: stickerModel.sticker.icon.fontFamily,
          package: stickerModel.sticker.icon.fontPackage,
          color: Colors.black87,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    
    // 선택된 스티커에 테두리 표시
    if (isSelected) {
      final borderPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: textPainter.width + 10,
        height: textPainter.height + 10,
      );
      
      canvas.drawRect(rect, borderPaint);
    }
    
    canvas.restore();
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
