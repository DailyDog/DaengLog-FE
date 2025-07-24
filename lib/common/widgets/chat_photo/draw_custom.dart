import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/painters/drawing_painter.dart';
import 'dart:math' as math;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// --- HandDrawn 테두리 Painter ---
class HandDrawnBorderPainter extends CustomPainter {
  HandDrawnBorderPainter({
    required this.color,
    required this.strokeWidth,
    this.amplitude = 4,
    this.segment = 20,
    this.jitter = 1.2,
  });

  final Color  color;
  final double strokeWidth;
  final double amplitude;
  final double segment;
  final double jitter;
  final _rand = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = color
      ..strokeWidth = strokeWidth
      ..style       = PaintingStyle.stroke
      ..strokeCap   = StrokeCap.round
      ..strokeJoin  = StrokeJoin.round;

    const radius = 32.0;
    final path = Path()..moveTo(radius, 0);

    // 상단
    _addLine(path, Offset(radius, 0), Offset(size.width - radius, 0), radius: radius);
         // ↘ 오른쪽 위 코너
     _addCorner(path, center: Offset(size.width - radius, radius), startAngle: -90, radius: radius);
     // 우측
     _addLine(path, Offset(size.width, radius), Offset(size.width, size.height - radius), radius: radius);
     // ↘ 오른쪽 아래 코너
     _addCorner(path, center: Offset(size.width - radius, size.height - radius), startAngle: 0, radius: radius);
     // 하단
     _addLine(path, Offset(size.width - radius, size.height), Offset(radius, size.height), radius: radius);
     // ↘ 왼쪽 아래 코너
     _addCorner(path, center: Offset(radius, size.height - radius), startAngle: 90, radius: radius);
     // 좌측
     _addLine(path, Offset(0, size.height - radius), Offset(0, radius), radius: radius);
     // ↘ 왼쪽 위 코너
     _addCorner(path, center: Offset(radius, radius), startAngle: 180, radius: radius);

    canvas.drawPath(path, paint);
  }

  // ---------------- helpers ----------------
  void _addLine(Path path, Offset start, Offset end, {required double radius}) {
    final length   = (end - start).distance;
    final segments = (length / segment).ceil();

    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final point = Offset.lerp(start, end, t)!;

      // 경계(i==segments)는 jitter 없음
      final jitterX = (i == segments) ? 0 : (_rand.nextDouble() - .5) * amplitude * jitter;
      final jitterY = (i == segments) ? 0 : (_rand.nextDouble() - .5) * amplitude * jitter;

      path.lineTo(point.dx + jitterX, point.dy + jitterY);
    }
  }

  /// startAngle: −90, 0, 90, 180 (deg)  ↔  우상, 우하, 좌하, 좌상
  void _addCorner(Path path, {required Offset center, required double startAngle, required double radius}) {
    final radStart = startAngle * math.pi / 180;
    final segments = ((math.pi / 2) * radius / segment).ceil();

    // 첫 점은 current point와 동일(즉 jitter=0) → ‘찢김’ 제거
    for (int i = 1; i <= segments; i++) {
      final angle = radStart + (i / segments) * math.pi / 2;
      // 각도 기반 위치
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      // 마지막 점(i==segments)은 jitter=0 → 다음 직선과 정확히 연결
      final isLast = i == segments;
      final jitterX = isLast ? 0 : (_rand.nextDouble() - .5) * amplitude * jitter * .4;
      final jitterY = isLast ? 0 : (_rand.nextDouble() - .5) * amplitude * jitter * .4;

      path.lineTo(x + jitterX, y + jitterY);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 색상 선택 위젯 ---
class ColorPickerWidget extends StatelessWidget {
  final Color selectedColor;
  final Function(Color) onColorChanged;
  final VoidCallback onEraserToggle;
  final bool isEraser;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.onEraserToggle,
    required this.isEraser,
  });

  void _showColorPicker(BuildContext context) {
    Color currentColor = selectedColor;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('사용자 지정 색상 선택', style: TextStyle(fontFamily: 'Pretendard-Bold')),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (color) {
                currentColor = color;
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                onColorChanged(currentColor);
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.purple,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 색상 원형 버튼들
          ...colors.map((color) => GestureDetector(
                onTap: () {
                  onColorChanged(color);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == color && !isEraser 
                          ? Colors.black 
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              )),
          GestureDetector(
                onTap: () {
                  _showColorPicker(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == Colors.transparent 
                          ? Colors.black 
                          : Colors.grey,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
          // 지우개 버튼
          GestureDetector(
            onTap: onEraserToggle,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isEraser ? Colors.black : Colors.transparent,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.cleaning_services,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 그림 그리기 오버레이 위젯 ---
class DrawCustomWidget extends StatelessWidget {
  final bool isDrawingMode;
  final GlobalKey imageKey;
  final double imageWidth;
  final double imageHeight;
  final List<DrawPoint?> points;
  final bool isEraser;
  final Color selectedColor;
  final Function(Offset, Color, double) onPanUpdate;
  final VoidCallback onPanEnd;

  const DrawCustomWidget({
    super.key,
    required this.isDrawingMode,
    required this.imageKey,
    required this.imageWidth,
    required this.imageHeight,
    required this.points,
    required this.isEraser,
    required this.selectedColor,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDrawingMode) return const SizedBox.shrink();

    return Positioned(
      left: 0,
      top: 0,
      width: imageWidth,
      height: imageHeight,
      child: GestureDetector(
        // 드래그로 그림 그리기
        onPanUpdate: (details) {
          final box = imageKey.currentContext!.findRenderObject() as RenderBox;
          final local = box.globalToLocal(details.globalPosition);
          final rel = Offset(local.dx / imageWidth, local.dy / imageHeight); // 이미지 비율에 맞게 좌표 변환
          
          if (isEraser) {
            // 지우개 모드일 때는 해당 영역의 점들을 제거
            onPanUpdate(rel, Colors.transparent, 8.0); // 지우개는 더 큰 반지름으로
          } else {
            // 일반 그리기 모드
            onPanUpdate(rel, selectedColor, 4.0);
          }
        },
        // 손 떼면 선 끊기(null로 구분)
        onPanEnd: (details) => onPanEnd(),
        child: CustomPaint(
          size: Size(imageWidth, imageHeight),
          painter: DrawingPainter(points, imageWidth, imageHeight),
        ),
      ),
    );
  }
}