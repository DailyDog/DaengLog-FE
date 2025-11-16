import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/painters/hand_drawn_wave_painter.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/photo_app_bar.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/photo_bottom_buttons.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/decoration_tools_widget.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/painters/image_draw_painter.dart';
import 'package:daenglog_fe/features/chat_photo/providers/photo_provider_manager.dart';
import 'package:daenglog_fe/features/chat_photo/services/photo_service.dart';
import 'package:daenglog_fe/features/chat_photo/providers/photo_screen_provider.dart';
import 'package:daenglog_fe/features/chat_photo/models/photo_sticker_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

// 포토카드 화면
class ChatPhotoScreen extends StatefulWidget {
  const ChatPhotoScreen({super.key});

  @override
  State<ChatPhotoScreen> createState() => _ChatPhotoScreenState();
}

class _ChatPhotoScreenState extends State<ChatPhotoScreen> {
  final GlobalKey contentKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey captureKey = GlobalKey();
  DecorationTool _selectedTool = DecorationTool.frame;
  bool _imageLoadRequested = false; // 이미지 로드 요청 플래그

  @override
  void initState() {
    super.initState();
    // 포토카드 화면에 진입할 때마다 상태 초기화 (이전 캡처/꾸미기 상태 제거)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PhotoScreenProvider>(context, listen: false);
      provider.reset();
    });
  }

  @override
  void dispose() {
    // 화면 종료 시 Provider 정리
    PhotoProviderManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhotoProviderScope(
      child: Consumer<PhotoScreenProvider>(
        builder: (context, provider, child) {
          return _buildPhotoScreen(context, provider);
        },
      ),
    );
  }

  Widget _buildPhotoScreen(BuildContext context, PhotoScreenProvider provider) {
    final gptResponse = GoRouterState.of(context).extra as DiaryGptResponse;
    final size = MediaQuery.of(context).size;
    final double imageHeight =
        provider.isDecorateMode ? size.height * 0.4 : size.height * 0.4;
    final double imageWidth =
        provider.isDecorateMode ? size.width * 0.8 : size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: PhotoAppBar(
        isDecorateMode: provider.isDecorateMode,
        onSave: () => provider.setDecorateMode(false),
        onDownload: () => _handleDownload(context, provider),
        gptResponse: gptResponse,
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: captureKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<PhotoScreenProvider>(
                      builder: (context, photoProvider, child) {
                        return _buildImageSection(context, photoProvider,
                            gptResponse, imageWidth, imageHeight);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTitleSection(gptResponse),
                    const SizedBox(height: 10),
                    if (!provider.isDecorateMode)
                      Consumer<PhotoScreenProvider>(
                        builder: (context, photoProvider, child) {
                          return _buildContentSection(
                              context, photoProvider, gptResponse);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 데코레이트 모드일 때 도구 위젯 표시
          if (provider.isDecorateMode)
            Align(
              alignment: Alignment.bottomCenter,
              child: DecorationToolsWidget(
                provider: provider,
                selectedTool: _selectedTool,
                onToolSelected: (tool) {
                  setState(() {
                    _selectedTool = tool;
                  });
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: provider.isDecorateMode
          ? null
          : PhotoBottomButtons(
              isConfirmed: provider.isConfirmed,
              imageLoaded: provider.imageLoaded,
              onLeftButtonPressed: () => provider.setDecorateMode(true),
              onRightButtonPressed: () => _captureImage(provider),
              onSharePressed: () =>
                  PhotoService.shareImage(provider.capturedImageBytes!),
              onCloudUploadPressed: () => _goToCloudUpload(provider),
            ),
    );
  }

  // 포토카드 사진 부분
  Widget _buildImageSection(
    BuildContext context,
    PhotoScreenProvider provider,
    DiaryGptResponse gptResponse,
    double imageWidth,
    double imageHeight,
  ) {
    // 이미지 로드 (한 번만 실행)
    if (!_imageLoadRequested && provider.backgroundImage == null) {
      _imageLoadRequested = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadNetworkImage(gptResponse.imageUrl);
      });
    }

    return Center(
      child: Stack(
        children: [
          SizedBox(
            key: imageKey,
            width: imageWidth,
            height: imageHeight,
            child: Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.red, width: 2), // 테스트용 빨간 테두리
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Consumer<PhotoScreenProvider>(
                  builder: (context, photoProvider, child) {
                    return GestureDetector(
                      onTapUp: (details) {
                        // 스티커 모드일 때만 처리
                        if (_selectedTool == DecorationTool.sticker &&
                            photoProvider.selectedSticker != null) {
                          final box = imageKey.currentContext
                              ?.findRenderObject() as RenderBox?;
                          final local =
                              box?.globalToLocal(details.globalPosition);

                          if (local != null) {
                            // 스티커 추가
                            photoProvider.addSticker(
                              PhotoStickerModel(
                                sticker: photoProvider.selectedSticker!,
                                position: local,
                                scale: 1.0,
                                rotation: 0.0,
                              ),
                            );
                          }
                        }
                      },
                      onPanStart: (details) {
                        if (!photoProvider.isDecorateMode) return;

                        final box = imageKey.currentContext?.findRenderObject()
                            as RenderBox?;
                        final local =
                            box?.globalToLocal(details.globalPosition);

                        if (local == null) return;

                        // 그리기 도구가 선택되었을 때만 그리기 실행
                        if (_selectedTool == DecorationTool.draw) {
                          photoProvider.startNewPath(local);
                        }
                        // 스티커 모드일 때 스티커 선택 확인
                        else if (_selectedTool == DecorationTool.sticker) {
                          // 스티커를 클릭했는지 확인
                          int? selectedIndex;
                          for (int i = photoProvider.placedStickers.length - 1;
                              i >= 0;
                              i--) {
                            final sticker = photoProvider.placedStickers[i];
                            final distance =
                                (sticker.position - local).distance;
                            if (distance < 30 * sticker.scale) {
                              selectedIndex = i;
                              break;
                            }
                          }
                          photoProvider.selectStickerByIndex(selectedIndex);
                        }
                      },
                      onPanUpdate: (details) {
                        if (!photoProvider.isDecorateMode) return;

                        final box = imageKey.currentContext?.findRenderObject()
                            as RenderBox?;
                        final local =
                            box?.globalToLocal(details.globalPosition);

                        if (local == null) return;

                        // 그리기 모드
                        if (_selectedTool == DecorationTool.draw) {
                          photoProvider.extendCurrentPath(local);
                        }
                        // 스티커 모드에서 선택된 스티커 이동
                        else if (_selectedTool == DecorationTool.sticker &&
                            photoProvider.selectedStickerIndex != null) {
                          photoProvider.updateStickerPosition(
                              photoProvider.selectedStickerIndex!, local);
                        }
                      },
                      onPanEnd: (details) {
                        // 그리기 종료 시 선택 해제
                        if (_selectedTool == DecorationTool.sticker) {
                          // 스티커 선택 유지
                        }
                      },
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: ImageDrawingPainter(
                            backgroundImage: photoProvider.backgroundImage,
                            drawingPaths: photoProvider.drawingPaths,
                            placedStickers: photoProvider.placedStickers,
                            selectedStickerIndex:
                                photoProvider.selectedStickerIndex,
                          ),
                          size: Size(imageWidth, imageHeight),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // 테두리 (터치 이벤트를 막지 않도록 IgnorePointer로 감싸기)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: provider.imageAndContentColor,
                    width: 3.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 포토카드 글 부분
  Widget _buildTitleSection(DiaryGptResponse gptResponse) {
    return Text(
      gptResponse.title,
      style: const TextStyle(
        fontFamily: 'Yeongdeok-Sea',
        fontWeight: FontWeight.w600,
        fontSize: 26,
        color: Color(0xFF272727),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildContentSection(BuildContext context,
      PhotoScreenProvider provider, DiaryGptResponse gptResponse) {
    final formattedDate = PhotoService.formatDate(gptResponse.date);
    final formattedContent =
        PhotoService.formatContent(gptResponse.content.replaceAll('\n', ' '));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...formattedContent.split('\n').map((line) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 15.0),
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
                      color: provider.imageAndContentColor,
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
          const SizedBox(height: 4),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 5,
            child: HandDrawnWave(
              color: provider.imageAndContentColor,
              strokeWidth: 2.3,
              amplitude: 1,
              segment: 3,
              jitter: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage(PhotoScreenProvider provider) async {
    try {
      print('🎯 이미지 캡처 시작...');
      final bytes = await PhotoService.captureAndConvertToJpg(captureKey);
      if (bytes != null) {
        provider.setCapturedImageBytes(bytes);
        print('✅ 이미지 캡처 성공: ${bytes.length} bytes');
      } else {
        print('❌ 이미지 캡처 실패: bytes가 null');
      }
    } catch (e) {
      print('❌ 이미지 캡처 오류: $e');
    }
  }

  void _handleDownload(BuildContext context, PhotoScreenProvider provider) {
    if (provider.capturedImageBytes != null) {
      PhotoService.saveImageToGallery(provider.capturedImageBytes!, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 확정하기를 눌러주세요.')),
      );
    }
  }

  Future<void> _goToCloudUpload(PhotoScreenProvider provider) async {
    // 캡처 이미지가 없으면 먼저 한 번 더 시도
    if (provider.capturedImageBytes == null) {
      await _captureImage(provider);
    }

    if (provider.capturedImageBytes != null) {
      final gptResponse = GoRouterState.of(context).extra as DiaryGptResponse;
      if (!mounted) return;
      context.push('/cloud_upload', extra: gptResponse);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('먼저 확정하기를 눌러주세요.')),
      );
    }
  }
}
