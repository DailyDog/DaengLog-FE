import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:daenglog_fe/features/chat_photo/widgets/painters/drawing_painter.dart';
import 'package:daenglog_fe/features/chat_photo/models/photo_sticker_model.dart';

class PhotoScreenProvider extends ChangeNotifier {
  // --- 상태 변수 ---
  bool _isConfirmed = false;
  Uint8List? _capturedImageBytes;
  bool _imageLoaded = false;
  bool _isDecorateMode = false;
  bool _isDrawingMode = false;

  // --- 그림 그리기 관련 상태 ---
  List<DrawPoint?> _points = [];
  Color _selectedColor = Colors.red;
  bool _isEraser = false;
  double _strokeWidth = 4.0;

  // --- 프레임 색상 관련 상태 ---
  Color _selectedFrameColor = const Color(0xFFFF6600);

  // --- 스티커 관련 상태 ---
  Sticker? _selectedSticker;
  List<PhotoStickerModel> _placedStickers = [];
  PhotoStickerModel? _selectedPlacedSticker;

  // --- Getters ---
  bool get isConfirmed => _isConfirmed;
  Uint8List? get capturedImageBytes => _capturedImageBytes;
  bool get imageLoaded => _imageLoaded;
  bool get isDecorateMode => _isDecorateMode;
  bool get isDrawingMode => _isDrawingMode;
  List<DrawPoint?> get points => _points;
  Color get selectedColor => _selectedColor;
  bool get isEraser => _isEraser;
  double get strokeWidth => _strokeWidth;
  Color get selectedFrameColor => _selectedFrameColor;
  Sticker? get selectedSticker => _selectedSticker;
  List<PhotoStickerModel> get placedStickers => _placedStickers;
  PhotoStickerModel? get selectedPlacedSticker => _selectedPlacedSticker;

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

  void setDecorateMode(bool mode) {
    _isDecorateMode = mode;
    notifyListeners();
  }

  void setDrawingMode(bool mode) {
    _isDrawingMode = mode;
    notifyListeners();
  }

  void setSelectedColor(Color color) {
    _selectedColor = color;
    _isEraser = false;
    notifyListeners();
  }

  void setEraserMode(bool isEraser) {
    _isEraser = isEraser;
    notifyListeners();
  }

  void setFrameColor(Color color) {
    _selectedFrameColor = color;
    // 프레임 색상 변경 시 캡처 상태 초기화
    _isConfirmed = false;
    _capturedImageBytes = null;
    notifyListeners();
  }

  void setSelectedSticker(Sticker? sticker) {
    _selectedSticker = sticker;
    notifyListeners();
  }

  void setSelectedPlacedSticker(PhotoStickerModel? sticker) {
    _selectedPlacedSticker = sticker;
    notifyListeners();
  }

  // --- 그림 그리기 메서드 ---
  void addDrawPoint(DrawPoint point) {
    _points.add(point);
    notifyListeners();
  }

  void addNullPoint() {
    _points.add(null);
    notifyListeners();
  }

  void clearPoints() {
    _points.clear();
    notifyListeners();
  }

  void erasePoints(Offset position, double strokeWidth) {
    final eraserRadius = strokeWidth / 8.0;
    final newPoints = <DrawPoint?>[];
    
    for (int i = 0; i < _points.length; i++) {
      final point = _points[i];
      if (point == null) {
        newPoints.add(null);
        continue;
      }
      
      final distance = (point.offset - position).distance;
      if (distance >= eraserRadius) {
        newPoints.add(point);
      }
    }
    
    _points.clear();
    _points.addAll(newPoints);
    notifyListeners();
  }

  // --- 스티커 관리 메서드 ---
  void addPlacedSticker(PhotoStickerModel sticker) {
    _placedStickers.add(sticker);
    _selectedSticker = null;
    notifyListeners();
  }

  void removePlacedSticker(PhotoStickerModel sticker) {
    _placedStickers.remove(sticker);
    if (_selectedPlacedSticker == sticker) {
      _selectedPlacedSticker = null;
    }
    notifyListeners();
  }

  void updatePlacedStickerPosition(PhotoStickerModel sticker, Offset newPosition) {
    final index = _placedStickers.indexOf(sticker);
    if (index != -1) {
      _placedStickers[index] = sticker.copyWith(position: newPosition);
      notifyListeners();
    }
  }

  // --- 초기화 메서드 ---
  void reset() {
    _isConfirmed = false;
    _capturedImageBytes = null;
    _isDecorateMode = false;
    _isDrawingMode = false;
    _points.clear();
    _selectedSticker = null;
    _placedStickers.clear();
    _selectedPlacedSticker = null;
    notifyListeners();
  }
}