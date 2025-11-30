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
  // 내용이 길어도 16:9 비율에 모두 들어가도록 스케일 조정
  static Future<Uint8List?> captureFullPhotoCard(GlobalKey contentKey) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final renderObject = contentKey.currentContext?.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        print('이미지 캡처 오류: 대상 위젯이 RepaintBoundary가 아닙니다.');
        return null;
      }

      RenderRepaintBoundary boundary = renderObject;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 16:9 세로 비율 계산 (가로:세로 = 9:16)
      final double targetWidth = image.width.toDouble();
      final double targetHeight = targetWidth * (16 / 9); 
      final double verticalMargin = targetHeight * 0.05;
      final double contentHeight = targetHeight - (verticalMargin * 2);

      // 원본 이미지의 실제 높이 확인
      final double originalHeight = image.height.toDouble();
      
      // 원본 이미지가 16:9 비율의 contentHeight보다 긴 경우
      // 전체 내용이 들어가도록 스케일 조정
      double scale;
      if (originalHeight > contentHeight) {
        // 내용이 길면 contentHeight에 맞춰서 스케일 다운
        scale = contentHeight / originalHeight;
      } else {
        // 내용이 짧으면 기존 로직대로 (가로/세로 중 작은 스케일 사용)
        final double widthScale = targetWidth / image.width;
        final double heightScale = contentHeight / image.height;
        scale = widthScale < heightScale ? widthScale : heightScale;
      }
      
      final double drawWidth = image.width * scale;
      final double drawHeight = image.height * scale;
      
      // 중앙 정렬
      final double left = (targetWidth - drawWidth) / 2;
      final double top = verticalMargin + (contentHeight - drawHeight) / 2;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
      );

      // 흰색 배경
      final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, targetWidth, targetHeight),
        bgPaint,
      );

      // 이미지 그리기
      final dstRect = Rect.fromLTWH(left, top, drawWidth, drawHeight);
      canvas.drawImageRect(
        image, 
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

  // --- 이미지 공유 ---
  static Future<void> shareImage(Uint8List capturedImageBytes, BuildContext context) async {
    try {
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/photo_card.jpg';
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(capturedImageBytes);
      
      // iOS에서 sharePositionOrigin 에러 방지: 올바른 좌표 설정
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        final size = box.size;
        final offset = box.localToGlobal(Offset.zero);
        await Share.shareXFiles(
          [XFile(imagePath)],
          sharePositionOrigin: Rect.fromLTWH(
            offset.dx,
            offset.dy,
            size.width,
            size.height,
          ),
        );
      } else {
        // RenderBox를 찾을 수 없으면 기본 방법 사용
        await Share.shareXFiles([XFile(imagePath)]);
      }
    } catch (e) {
      print('이미지 공유 오류: $e');
      // 에러 발생 시 기본 방법으로 재시도
      try {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/photo_card.jpg';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(capturedImageBytes);
        await Share.shareXFiles([XFile(imagePath)]);
      } catch (e2) {
        print('이미지 공유 재시도 오류: $e2');
        rethrow;
      }
    }
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

  // [변경] 화면 너비와 스타일을 기준으로 텍스트를 자연스럽게 나누는 함수
  static List<String> splitTextByWidth({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    if (text.isEmpty) return [];

    final textSpan = TextSpan(text: text, style: style);
    
    // 1. TextPainter를 사용하여 텍스트 레이아웃 계산
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(maxWidth: maxWidth);

    // 2. 계산된 라인 정보를 가져옴
    final metrics = textPainter.computeLineMetrics();
    List<String> lines = [];
    int start = 0;
    
    for (final line in metrics) {
      // 각 줄의 끝 지점을 찾음 (해당 라인의 오른쪽 끝 좌표에 해당하는 텍스트 인덱스 추출)
      final endPosition = textPainter.getPositionForOffset(
        Offset(maxWidth, line.baseline - line.descent),
      );
      
      int end = endPosition.offset;
      
      // 범위 체크
      if (end > text.length) end = text.length;
      if (start >= end) break; 

      // 텍스트 자르기 & 공백 정리
      String sub = text.substring(start, end);
      lines.add(sub.trimRight());
      
      start = end;
    }

    // 만약 계산 과정에서 누락된 끝부분이 있다면 추가 (안전장치)
    if (start < text.length) {
      lines.add(text.substring(start).trim());
    }

    return lines;
  }

  // --- (구) 텍스트 줄바꿈 처리 - 필요 없다면 삭제 가능 ---
  static String formatContent(String text, {int chunk = 26}) {
    if (text.isEmpty) return text;
    final buffer = StringBuffer();
    var currentLine = StringBuffer();
    var count = 0;
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