import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:daenglog_fe/models/chat/gpt_response.dart';
import 'package:daenglog_fe/common/painters/hand_drawn_wave_painter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:daenglog_fe/common/painters/drawing_painter.dart';
import 'package:daenglog_fe/features/chat_photo/image_custom.dart';
import 'package:daenglog_fe/common/widgets/chat_photo/draw_custom.dart';
import 'package:daenglog_fe/common/widgets/others/default_profile.dart';
import 'package:provider/provider.dart';

// 스티커 모델 클래스
class StickerItem {
  final IconData icon;
  final String name;
  final Color color;
  final double size;

  StickerItem({
    required this.icon,
    required this.name,
    required this.color,
    this.size = 40.0,
  });
}

// 이미지 위에 배치된 스티커 모델
class PlacedSticker {
  final StickerItem sticker;
  final Offset position;
  final double scale;
  final double rotation;

  PlacedSticker({
    required this.sticker,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  PlacedSticker copyWith({
    StickerItem? sticker,
    Offset? position,
    double? scale,
    double? rotation,
  }) {
    return PlacedSticker(
      sticker: sticker ?? this.sticker,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }
}

class ChatPhoto extends StatefulWidget {
  const ChatPhoto({super.key});

  @override
  State<ChatPhoto> createState() => _ChatPhotoState();
}

class _ChatPhotoState extends State<ChatPhoto> {
  // --- 상태 변수 ---
  bool isConfirmed = false; // 확정 플래그
  Uint8List? capturedImageBytes; // 이미지 바이트 데이터
  final GlobalKey contentKey = GlobalKey(); // 전체 캡처용 키
  bool imageLoaded = false; // 이미지 로딩 플래그
  bool isDecorateMode = false; // 일기 꾸미기 모드 플래그
  bool isDrawingMode = false; // 그림 그리기 모드 플래그
  final GlobalKey imageKey = GlobalKey(); // 이미지 위젯 키(좌표 변환용)

  // --- 그림 그리기 관련 상태 ---
  List<DrawPoint?> points = []; // 그리기 포인트(색상, 좌표, 두께)
  Color selectedColor = Colors.red; // 현재 선택된 색상
  bool isEraser = false; // 지우개 모드 여부
  double strokeWidth = 4.0; // 선 두께

  // --- 프레임 색상 관련 상태 ---
  Color selectedFrameColor = const Color(0xFFFF6600); // 선택된 프레임 색상 (기본: 오렌지)

  // --- 스티커 관련 상태 ---
  StickerItem? selectedSticker; // 현재 선택된 스티커
  List<PlacedSticker> placedStickers = []; // 이미지 위에 배치된 스티커들
  PlacedSticker? selectedPlacedSticker; // 현재 선택된 배치된 스티커 (드래그/조작용)

  // --- 이미지 캡처 ---
  Future<void> captureAndConvertToJpg() async {
    try {
      // 프레임 색상 변경이 반영되도록 더 긴 지연 시간
      await Future.delayed(const Duration(milliseconds: 200));
      RenderRepaintBoundary boundary = contentKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        setState(() {
          capturedImageBytes = byteData.buffer.asUint8List();
          isConfirmed = true;
        });
      }
    } catch (e) {
      print('이미지 캡처 오류: $e');
    }
  }

  // --- 이미지 공유 ---
  void shareImage() async {
    if (capturedImageBytes == null) return;
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/photo_card.jpg';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(capturedImageBytes!);
    await Share.shareXFiles([
      XFile(imagePath),
    ]);
  }

  @override
  Widget build(BuildContext context) {

    final defaultProfile = context.watch<DefaultProfile>();

    // 일기 데이터
    final gptResponse = ModalRoute.of(context)?.settings.arguments as GptResponse; // 일기 데이터
    String content(String text, {int chunk = 26}) => RegExp('.{1,$chunk}').allMatches(text).map((m) => m.group(0)).join('\n'); // 일기 내용 줄바꿈
    String formattedDate = gptResponse.date.length >= 10 // 날짜 포맷팅
        ? DateFormat('yy.MM.dd').format(DateTime.parse(gptResponse.date))
        : gptResponse.date; // 날짜 포맷팅 안될 때

    // 반응형 처리
    final size = MediaQuery.of(context).size; // 화면 크기
    final double imageHeight = size.height * (isDecorateMode ? 0.45 : 0.35); // 이미지 높이
    final double imageWidth = size.width * (isDecorateMode ? 0.7 : 0.8); // 이미지 너비

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFFF6600)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('', style: TextStyle(fontFamily: 'Pretendard-Bold', color: Color(0xFF272727))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: isDecorateMode
                ? IconButton(
                    icon: const Icon(Icons.save, color: Color(0xFFFF6600)),
                    onPressed: () {
                      setState(() {
                        isDecorateMode = false;
                      });
                    },
                  )
                : const Icon(Icons.cloud_upload_outlined, color: Color(0xFFFF6600)),
          ),
        ],
      ),
      body: RepaintBoundary(
        key: contentKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- 그림 그리기 오버레이 ---
                Center(
                  child: Stack(
                    children: [
                      Container(
                        key: imageKey,
                        width: imageWidth,
                        height: imageHeight,
                        child: Stack(
                          children: [
                            // 이미지
                            Container(
                              width: imageWidth,
                              height: imageHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                gptResponse.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    if (!imageLoaded) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        setState(() {
                                          imageLoaded = true;
                                        });
                                      });
                                    }
                                    return child;
                                  } else {
                                    return const Center(child: CircularProgressIndicator());
                                  }
                                },
                                errorBuilder: (c, e, s) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.pets, size: 80, color: Color(0xFFFF6600)),
                                ),
                              ),
                            ),
                            // HandDrawnWave 테두리
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: CustomPaint(
                                  painter: HandDrawnBorderPainter(
                                    color: selectedFrameColor,
                                    strokeWidth: 3.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // --- 그림 그리기 오버레이 위젯 ---
                      DrawCustomWidget(
                        isDrawingMode: isDrawingMode,
                        imageKey: imageKey,
                        imageWidth: imageWidth,
                        imageHeight: imageHeight,
                        points: points,
                        isEraser: isEraser,
                        selectedColor: selectedColor,
                        onPanUpdate: (rel, color, strokeWidth) {
                          setState(() {
                            if (color == Colors.transparent) {
                              // 지우개 모드: 해당 영역의 점들을 제거
                              final eraserRadius = strokeWidth / 8.0; // 지우개 반지름을 더 작게
                              final newPoints = <DrawPoint?>[];
                              
                              for (int i = 0; i < points.length; i++) {
                                final point = points[i];
                                if (point == null) {
                                  newPoints.add(null);
                                  continue;
                                }
                                
                                final distance = (point.offset - rel).distance;
                                if (distance >= eraserRadius) {
                                  // 지우개 반지름 밖에 있는 점은 유지
                                  newPoints.add(point);
                                }
                                // 지우개 반지름 안에 있는 점은 제거 (null로 대체하지 않음)
                              }
                              
                              points.clear();
                              points.addAll(newPoints);
                            } else {
                              // 일반 그리기 모드
                              points = List.from(points)..add(DrawPoint(rel, color, strokeWidth));
                            }
                          });
                        },
                        onPanEnd: () {
                          setState(() => points.add(null));
                        },
                      ),
                      // --- 스티커 오버레이 ---
                      if (isDecorateMode)
                        Positioned.fill(
                          child: GestureDetector(
                            onTapDown: (details) {
                              if (selectedSticker != null) {
                                // 이미지 좌표계로 변환
                                final RenderBox renderBox = imageKey.currentContext!.findRenderObject() as RenderBox;
                                final localPosition = renderBox.globalToLocal(details.globalPosition);
                                
                                // 포토카드 전체 영역에서 스티커 배치 가능
                                setState(() {
                                  placedStickers.add(PlacedSticker(
                                    sticker: selectedSticker!,
                                    position: localPosition,
                                  ));
                                  selectedSticker = null; // 스티커 선택 해제
                                });
                              }
                            },
                            child: Stack(
                              children: [
                                // 배치된 스티커들 표시
                                ...placedStickers.map((placedSticker) => Positioned(
                                  left: placedSticker.position.dx - placedSticker.sticker.size / 2,
                                  top: placedSticker.position.dy - placedSticker.sticker.size / 2,
                                                                      child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedPlacedSticker = placedSticker;
                                        });
                                      },
                                      onLongPress: () {
                                        // 스티커 삭제 확인 다이얼로그
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('스티커 삭제'),
                                              content: Text('${placedSticker.sticker.name} 스티커를 삭제하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text('취소'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      placedStickers.remove(placedSticker);
                                                      selectedPlacedSticker = null;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text('삭제'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onPanUpdate: (details) {
                                        if (selectedPlacedSticker == placedSticker) {
                                          setState(() {
                                            final index = placedStickers.indexOf(placedSticker);
                                            if (index != -1) {
                                              final RenderBox renderBox = imageKey.currentContext!.findRenderObject() as RenderBox;
                                              final localPosition = renderBox.globalToLocal(details.globalPosition);
                                              
                                              // 포토카드 전체 영역에서 이동 가능
                                              placedStickers[index] = placedSticker.copyWith(
                                                position: localPosition,
                                              );
                                            }
                                          });
                                        }
                                      },
                                      onPanEnd: (details) {
                                        setState(() {
                                          selectedPlacedSticker = null;
                                        });
                                      },
                                    child: Transform.scale(
                                      scale: placedSticker.scale,
                                      child: Transform.rotate(
                                        angle: placedSticker.rotation,
                                        child: Container(
                                          width: placedSticker.sticker.size,
                                          height: placedSticker.sticker.size,
                                          decoration: BoxDecoration(
                                            color: selectedPlacedSticker == placedSticker 
                                                ? Colors.blue.withOpacity(0.3)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            placedSticker.sticker.icon,
                                            color: placedSticker.sticker.color,
                                            size: placedSticker.sticker.size,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )).toList(),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                              gptResponse.title,
                              style: const TextStyle(
                                fontFamily: 'Yeongdeok-Sea',
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: Color(0xFF272727),
                              ),
                              textAlign: TextAlign.center,
                            ),
                const SizedBox(height:10),
                // --- 꾸미기 모드: 꾸미기 메뉴 ---
                isDecorateMode // 꾸미기 모드일 때
                  ? ImageCustomWidget( // 꾸미기 메뉴 목록
                      onComplete: () {
                        setState(() {
                          isDecorateMode = false;
                        });
                      },
                      onDrawingMode: () {
                        setState(() {
                          isDrawingMode = true;
                        });
                      },
                      selectedColor: selectedColor,
                      isEraser: isEraser,
                      onColorChanged: (color) {
                        setState(() {
                          selectedColor = color;
                          isEraser = false;
                        });
                      },
                      onEraserToggle: () {
                        setState(() {
                          isEraser = true;
                        });
                      },
                      selectedFrameColor: selectedFrameColor,
                      onFrameColorChanged: (color) {
                        setState(() {
                          selectedFrameColor = color;
                        });
                        // 프레임 색상 변경 후 강제 리빌드 및 캡처 상태 초기화
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            isConfirmed = false; // 캡처 상태 초기화
                            capturedImageBytes = null; // 기존 캡처 데이터 초기화
                          });
                        });
                      },
                      onStickerSelected: (sticker) {
                        setState(() {
                          selectedSticker = StickerItem(
                            icon: sticker.icon,
                            name: sticker.name,
                            color: const Color(0xFF272727),
                            size: 40.0,
                          );
                        });
                      },
                    )
                  // --- 꾸미기 모드가 아닐 때: 원래 본문 ---
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...content(gptResponse.content.replaceAll('\n', ' '))
                              .split('\n')
                              .map((line) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:30.0, right:15.0),
                                        child: Text(
                                          line,
                                          style: const TextStyle(
                                            fontFamily: 'Yeongdeok-Sea',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Color(0xFF272727),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 20),
                                        width: double.infinity,
                                        height: 5,
                                        child: HandDrawnWave(
                                          color: selectedFrameColor,
                                          strokeWidth: 2.3,
                                          amplitude: 1,
                                          segment: 3,
                                          jitter: 1.5,
                                        ),
                                      ),
                                    ],
                                  )),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(width: 8),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      fontFamily: 'Yeongdeok-Sea',
                                      fontSize: 19,
                                      color: Color(0xFFEB0B0B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Image.asset(
                                    'assets/images/home/daeng.png',
                                    width: 20,
                                    height: 28,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height:4),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            height: 5,
                            child: HandDrawnWave(
                              color: selectedFrameColor,
                              strokeWidth: 2.3,
                              amplitude: 1,
                              segment: 3,
                              jitter: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      // --- 하단 버튼: 꾸미기 모드일 때는 숨김 ---
      bottomNavigationBar: isDecorateMode
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            isDecorateMode = true;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF6600)),
                          foregroundColor: const Color(0xFFFF6600),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          '일기 꾸미기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: imageLoaded ? (isConfirmed ? shareImage : captureAndConvertToJpg) : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6600),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: Text(
                          isConfirmed ? '공유하기' : '확정하기',
                          style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

