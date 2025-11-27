import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:characters/characters.dart';

class PhotoService {
  // --- 전체 포토카드 캡처 (이미지 + 제목 + 텍스트 + 선 등 모든 요소 포함) ---
  static Future<Uint8List?> captureFullPhotoCard(GlobalKey contentKey) async {
    try {
      // 프레임 색상 변경이 반영되도록 더 긴 지연 시간
      await Future.delayed(const Duration(milliseconds: 300));
      final renderObject = contentKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        print('이미지 캡처 오류: 대상 위젯이 RepaintBoundary가 아닙니다.');
        return null;
      }

      RenderRepaintBoundary boundary = renderObject;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // ---- 9:16 세로 비율, 흰 배경으로 다시 그리기 ----
      // 원본 이미지의 가로를 기준으로 9:16 세로 비율 계산
      final double targetWidth = image.width.toDouble();
      final double targetHeight = targetWidth * (16 / 9); // 9:16 세로 비율 (가로:세로 = 9:16)

      // 상하 마진 설정 (전체 높이의 5%)
      final double verticalMargin = targetHeight * 0.05;
      final double contentHeight = targetHeight - (verticalMargin * 2);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
      );

      // 흰색 배경 확인 및 설정
      final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
        bgPaint,
      );

      // 전체 포토카드를 contentHeight 안에 맞도록 스케일 계산
      final double widthScale = targetWidth / image.width;
      final double heightScale = contentHeight / image.height;
      final double scale = widthScale < heightScale ? widthScale : heightScale; // 더 작은 스케일 사용하여 비율 유지
      
      final double drawWidth = image.width * scale;
      final double drawHeight = image.height * scale;
      final double left = (targetWidth - drawWidth) / 2;
      final double top = verticalMargin + (contentHeight - drawHeight) / 2;
      
      final dstRect = Rect.fromLTWH(
        left,
        top,
        drawWidth,
        drawHeight,
      );

      canvas.drawImageRect(image, 
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), 
        dstRect, 
        Paint()
      );

      final composedImage =
          await recorder.endRecording().toImage(targetWidth.toInt(), targetHeight.toInt());

      ByteData? byteData =
          await composedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      print('전체 포토카드 캡처 오류: $e');
    }
    return null;
  }

  // --- 이미지 영역만 캡처 (기존 메서드, 하위 호환성 유지) ---
  static Future<Uint8List?> captureAndConvertToJpg(GlobalKey contentKey) async {
    try {
      // 프레임 색상 변경이 반영되도록 더 긴 지연 시간
      await Future.delayed(const Duration(milliseconds: 200));
      final renderObject = contentKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        print('이미지 캡처 오류: 대상 위젯이 RepaintBoundary가 아닙니다.');
        return null;
      }

      RenderRepaintBoundary boundary = renderObject;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // ---- 9:16 세로 비율, 흰 배경으로 다시 그리기 ----
      // 원본 이미지의 가로를 기준으로 9:16 세로 비율 계산
      final double targetWidth = image.width.toDouble();
      final double targetHeight = targetWidth * (16 / 9); // 9:16 세로 비율 (가로:세로 = 9:16)

      // 상하 마진 설정 (전체 높이의 5%)
      final double verticalMargin = targetHeight * 0.05;
      final double contentHeight = targetHeight - (verticalMargin * 2);

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
      );

      // 흰색 배경 확인 및 설정
      final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
        bgPaint,
      );

      // 이미지 비율 유지하면서 중앙에 배치 (상하 마진 적용)
      final srcRect =
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      
      // 이미지가 contentHeight 안에 맞도록 스케일 계산
      final double widthScale = targetWidth / image.width;
      final double heightScale = contentHeight / image.height;
      final double scale = widthScale < heightScale ? widthScale : heightScale; // 더 작은 스케일 사용하여 비율 유지
      
      final double drawWidth = image.width * scale;
      final double drawHeight = image.height * scale;
      final double left = (targetWidth - drawWidth) / 2;
      final double top = verticalMargin + (contentHeight - drawHeight) / 2;
      
      final dstRect = Rect.fromLTWH(
        left,
        top,
        drawWidth,
        drawHeight,
      );

      canvas.drawImageRect(image, srcRect, dstRect, Paint());

      final composedImage =
          await recorder.endRecording().toImage(targetWidth.toInt(), targetHeight.toInt());

      ByteData? byteData =
          await composedImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        return byteData.buffer.asUint8List();
      }
    } catch (e) {
      print('이미지 캡처 오류: $e');
    }
    return null;
  }

  // --- 이미지 공유 ---
  static Future<void> shareImage(Uint8List capturedImageBytes) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/photo_card.jpg';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(capturedImageBytes);
    await Share.shareXFiles([
      XFile(imagePath),
    ]);
  }

  // --- 갤러리에 이미지 저장 ---
  static Future<bool> saveImageToGallery(
      Uint8List capturedImageBytes, BuildContext context) async {
    try {
      final result = await ImageGallerySaver.saveImage(
        capturedImageBytes,
        quality: 100,
        name: 'daenglog_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('갤러리에 저장되었습니다!')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('저장에 실패했습니다.')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장 중 오류가 발생했습니다.')),
      );
      return false;
    }
  }

  // --- 날짜 포맷팅 ---
  static String formatDate(String date) {
    if (date.length >= 10) {
      return '${date.substring(2, 4)}.${date.substring(5, 7)}.${date.substring(8, 10)}';
    }
    return date;
  }

  // --- 텍스트 줄바꿈 처리 ---
  static String formatContent(String text, {int chunk = 26}) {
    if (text.isEmpty) return text;

    final buffer = StringBuffer();
    var currentLine = StringBuffer();
    var count = 0;

    // characters 패키지를 사용해 이모지/조합 문자가 중간에 끊기지 않도록 처리
    for (final ch in text.characters) {
      if (count >= chunk && ch != ' ') {
        buffer.writeln(currentLine.toString().trimRight());
        currentLine = StringBuffer();
        count = 0;
      }

      currentLine.write(ch);
      count++;
    }

    if (currentLine.isNotEmpty) {
      buffer.write(currentLine.toString().trimRight());
    }

    return buffer.toString();
  }

  // --- 이미지 좌표 변환 ---
  static Offset convertToImageCoordinates(
      Offset globalPosition, GlobalKey imageKey) {
    final RenderBox renderBox =
        imageKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(globalPosition);
  }
}
