import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:daenglog_fe/shared/widgets/daeng_toast.dart';
import 'package:characters/characters.dart';

class PhotoService {
  // --- 이미지 캡처 ---
  static Future<Uint8List?> captureAndConvertToJpg(GlobalKey contentKey) async {
    try {
      // 프레임 색상 변경이 반영되도록 더 긴 지연 시간
      await Future.delayed(const Duration(milliseconds: 200));
      RenderRepaintBoundary boundary = contentKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 투명 배경 대신 흰색 배경으로 한 번 더 렌더링
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      );

      // 흰색 배경
      final paint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint,
      );

      // 원본 이미지 덧그리기
      canvas.drawImage(image, Offset.zero, Paint());

      final composedImage =
          await recorder.endRecording().toImage(image.width, image.height);

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
        showDaengToast(context, '갤러리에 저장되었습니다!');
        return true;
      } else {
        showDaengToast(context, '저장에 실패했습니다.', isWarning: true);
        return false;
      }
    } catch (e) {
      showDaengToast(context, '저장 중 오류가 발생했습니다.', isWarning: true);
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
