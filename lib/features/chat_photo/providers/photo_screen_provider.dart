import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:daenglog_fe/features/chat_photo/models/drawing_path_model.dart';
import 'package:daenglog_fe/features/chat_photo/models/photo_sticker_model.dart';
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
    // 데코레이트 모드 종료 시 선택 상태 초기화
    if (!mode) {
      _selectedSticker = null;
      _selectedStickerIndex = null;
    }
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
    _drawingPaths.clear();
    _placedStickers.clear();
    _selectedSticker = null;
    _selectedStickerIndex = null;
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
        _imageLoaded = true; // 이미 로드된 경우도 true로 설정
        notifyListeners();
        return;
      }

      _currentImageUrl = imageUrl; // 현재 로딩 중인 URL 저장
      _imageLoaded = false; // 로딩 시작 시 false
      notifyListeners();

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
        _imageLoaded = true; // 이미지 로드 성공 시 true
        notifyListeners();
        print('✅ 이미지 로드 성공: ${bytes.length} bytes');
      }
    } catch (e) {
      print('❌ 이미지 로드 실패: $e');
      _currentImageUrl = null; // 실패 시 URL 초기화
      _imageLoaded = false; // 실패 시 false
      notifyListeners();
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

    final path = Path()..moveTo(startPoint.dx, startPoint.dy);

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

// --------스티커 관련 상태관리---------

  List<PhotoStickerModel> _placedStickers = [];
  Sticker? _selectedSticker;
  int? _selectedStickerIndex;

  // getter
  List<PhotoStickerModel> get placedStickers => _placedStickers;
  Sticker? get selectedSticker => _selectedSticker;
  int? get selectedStickerIndex => _selectedStickerIndex;

  // 스티커 선택
  void selectSticker(Sticker sticker) {
    _selectedSticker = sticker;
    notifyListeners();
  }

  // 스티커 추가
  void addSticker(PhotoStickerModel sticker) {
    _placedStickers.add(sticker);
    notifyListeners();
  }

  // 스티커 위치 업데이트
  void updateStickerPosition(int index, Offset position) {
    if (index >= 0 && index < _placedStickers.length) {
      _placedStickers[index] =
          _placedStickers[index].copyWith(position: position);
      notifyListeners();
    }
  }

  // 스티커 크기 업데이트
  void updateStickerScale(int index, double scale) {
    if (index >= 0 && index < _placedStickers.length) {
      _placedStickers[index] = _placedStickers[index].copyWith(scale: scale);
      notifyListeners();
    }
  }

  // 스티커 회전 업데이트
  void updateStickerRotation(int index, double rotation) {
    if (index >= 0 && index < _placedStickers.length) {
      _placedStickers[index] =
          _placedStickers[index].copyWith(rotation: rotation);
      notifyListeners();
    }
  }

  // 스티커 삭제
  void removeSticker(int index) {
    if (index >= 0 && index < _placedStickers.length) {
      _placedStickers.removeAt(index);
      _selectedStickerIndex = null;
      notifyListeners();
    }
  }

  // 선택된 스티커 인덱스 설정
  void selectStickerByIndex(int? index) {
    _selectedStickerIndex = index;
    notifyListeners();
  }

  // 모든 스티커 삭제
  void clearStickers() {
    _placedStickers.clear();
    _selectedStickerIndex = null;
    notifyListeners();
  }
}
