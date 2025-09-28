import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

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
