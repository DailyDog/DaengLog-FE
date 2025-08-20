import 'package:flutter/material.dart';

// PhotoPlacedSticker 클래스 (필요한 경우 별도 파일로 분리 가능)
class PhotoStickerModel {
  final Sticker sticker;
  final Offset position;
  final double scale;
  final double rotation;

  PhotoStickerModel({
    required this.sticker,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  PhotoStickerModel copyWith({
    Sticker? sticker,
    Offset? position,
    double? scale,
    double? rotation,
  }) {
    return PhotoStickerModel(
      sticker: sticker ?? this.sticker,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }
} 

// --- 스티커 모델 ---
class Sticker {
  final String id;
  final IconData icon;
  final String name;
  final String category;

  const Sticker({
    required this.id,
    required this.icon,
    required this.name,
    required this.category,
  });
}