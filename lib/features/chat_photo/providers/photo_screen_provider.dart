import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:daenglog_fe/features/chat_photo/models/drawing_path_model.dart';
import 'package:dio/dio.dart';

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
  String? _currentImageUrl;


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

  // 네트워크 이미지를 ui.Image로 변환하여 로드 (Dio 사용)
  Future<void> loadNetworkImage(String imageUrl) async {
    try {
      // 이미 같은 URL의 이미지가 로드되어 있으면 스킵
      if (_backgroundImage != null && _currentImageUrl == imageUrl) {
        return;
      }
      
      _currentImageUrl = imageUrl; // 현재 로딩 중인 URL 저장
      
      final dio = Dio();
      final response = await dio.get<List<int>>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data!);
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        _backgroundImage = frame.image;
        notifyListeners();
        print('이미지 로드 성공: ${bytes.length} bytes');
      }
    } catch (e) {
      print('이미지 로드 실패: $e');
      _currentImageUrl = null; // 실패 시 URL 초기화
    }
  }

  // 새 경로 시작
  void startNewPath(Offset startPoint) {
    print('🎨 startNewPath 호출됨: $startPoint');
    print('🎨 현재 색상: $_selectedColor');
    print('🎨 현재 굵기: $_strokeWidth');
    
    final paint = Paint()
      ..color = _selectedColor
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(startPoint.dx, startPoint.dy);

    _drawingPaths.add(
      DrawingPathModel(path: path, paint: paint, tool: _selectedTool),
    );
    print('🎨 경로 추가됨. 총 경로 수: ${_drawingPaths.length}');
    notifyListeners();
  }

  // 현재 경로 연장
  void extendCurrentPath(Offset point) {
    if (_drawingPaths.isEmpty) {
      print('⚠️ extendCurrentPath: 경로가 비어있음');
      return;
    }
    _drawingPaths.last.path.lineTo(point.dx, point.dy);
    print('🎨 경로 연장됨: $point');
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _strokeWidth = width;
    notifyListeners();
  }

  
}