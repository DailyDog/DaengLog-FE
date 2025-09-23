import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:daenglog_fe/features/chat_photo/models/drawing_path_model.dart';

class PhotoScreenProvider extends ChangeNotifier {

  // --- 상태 변수 ---
  bool _isConfirmed = false;
  Uint8List? _capturedImageBytes;
  bool _imageLoaded = false;
  bool _isDecorateMode = false;
  Color _imageAndContentColor = Color(0xFFF56F01);

  // --- Getters ---
  bool get isConfirmed => _isConfirmed;
  Uint8List? get capturedImageBytes => _capturedImageBytes;
  bool get imageLoaded => _imageLoaded;
  bool get isDecorateMode => _isDecorateMode;
  Color get imageAndContentColor => _imageAndContentColor;

  // --- Setters ---
  void setImageLoaded(bool loaded) {
    _imageLoaded = loaded;
    notifyListeners();
  }

  void setCapturedImageBytes(Uint8List? bytes) {
    _capturedImageBytes = bytes;
    _isConfirmed = bytes != null;
    notifyListeners();
  }

  // 일기 꾸미기 모드인지
  void setDecorateMode(bool mode) {
    _isDecorateMode = mode;
    notifyListeners();
  }

  // 이미지 프레임 색상 변경시
  void setImageAndContentColor(Color color) {
    _imageAndContentColor = color;
    notifyListeners();
  }

  // --- 초기화 메서드 ---
  void reset() {
    _isConfirmed = false;
    _capturedImageBytes = null;
    _isDecorateMode = false;
    notifyListeners();
  }

// --------그리기 관련 상태관리---------

  List<DrawingPathModel> _drawingPaths = [];
  Color _selectedColor = Colors.red;
  double _strokeWidth = 3.0;
  DrawingTool _selectedTool = DrawingTool.pen;
  ui.Image? _backgroundImage;


  // getter
  List<DrawingPathModel> get drawingPaths => _drawingPaths;
  Color get selectedColor => _selectedColor;
  double get strokeWidth => _strokeWidth;
  DrawingTool get selectedTool => _selectedTool;
  ui.Image? get backgroundImage => _backgroundImage;

  // 그리기 경로 추가
  void addDrawingPath(DrawingPathModel path) {
    _drawingPaths.add(path);
    notifyListeners();
  }

  // 실행 취소
  void undoLastPath() {
    if (_drawingPaths.isNotEmpty) {
      _drawingPaths.removeLast();
      notifyListeners();
    }
  }
  
  // 모든 그리기 지우기
  void clearDrawing() {
    _drawingPaths.clear();
    notifyListeners();
  }
  
  // 도구/색상 변경
  void setSelectedTool(DrawingTool tool) {
    _selectedTool = tool;
    notifyListeners();
  }
  
  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }
  
  // 이미지 로드
  void setBackgroundImage(ui.Image image) {
    _backgroundImage = image;
    notifyListeners();
  }

  
}