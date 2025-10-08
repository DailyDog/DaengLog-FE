import 'package:flutter/material.dart';

// 그리기 도구 열거형
enum DrawingTool {
  pen,
  eraser,
  line,
  rectangle,
  circle
}

// 그리기 경로 클래스
class DrawingPathModel {
  final Path path;
  final Paint paint;
  final DrawingTool tool;
  
  DrawingPathModel({
    required this.path,
    required this.paint,
    required this.tool,
  });
}
