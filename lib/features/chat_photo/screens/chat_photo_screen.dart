import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/painters/hand_drawn_wave_painter.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/photo_app_bar.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/photo_bottom_buttons.dart';
import 'package:daenglog_fe/features/chat_photo/widgets/decoration_tools_widget.dart';
import 'package:daenglog_fe/features/chat_photo/providers/photo_screen_provider.dart';
import 'package:daenglog_fe/features/chat_photo/services/photo_service.dart';
import 'package:provider/provider.dart';

// 포토카드 화면
class ChatPhotoScreen extends StatefulWidget {
  const ChatPhotoScreen({super.key});

  @override
  State<ChatPhotoScreen> createState() => _ChatPhotoScreenState();
}

class _ChatPhotoScreenState extends State<ChatPhotoScreen> {
  final GlobalKey contentKey = GlobalKey();
  final GlobalKey imageKey = GlobalKey();
  DecorationTool _selectedTool = DecorationTool.frame;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PhotoScreenProvider(),
      child: Consumer<PhotoScreenProvider>(
        builder: (context, provider, child) {
          return _buildPhotoScreen(context, provider);
        },
      ),
    );
  }

  Widget _buildPhotoScreen(BuildContext context, PhotoScreenProvider provider) {
    final gptResponse = ModalRoute.of(context)?.settings.arguments as DiaryGptResponse;
    final size = MediaQuery.of(context).size;
    final double imageHeight = provider.isDecorateMode 
        ? size.height * 0.4 
        : size.height * 0.4;
    final double imageWidth = provider.isDecorateMode 
        ? size.width * 0.8 
        : size.width * 0.8;

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
            key: contentKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Consumer<PhotoScreenProvider>(
                      builder: (context, photoProvider, child) {
                        return _buildImageSection(context, photoProvider, gptResponse, imageWidth, imageHeight);
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTitleSection(gptResponse),
                    const SizedBox(height: 10),
                    if (!provider.isDecorateMode)
                      Consumer<PhotoScreenProvider>(
                          builder: (context, photoProvider, child) {
                            return _buildContentSection(context, photoProvider, gptResponse);
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
              onSharePressed: () => PhotoService.shareImage(provider.capturedImageBytes!),
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
    return Center(
      child: Stack(
        children: [
          SizedBox(
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
                        if (!provider.imageLoaded) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            provider.setImageLoaded(true);
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
                // 테두리
                Positioned.fill(
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
              ],
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

  Widget _buildContentSection(BuildContext context, PhotoScreenProvider provider, DiaryGptResponse gptResponse) {
    final formattedDate = PhotoService.formatDate(gptResponse.date);
    final formattedContent = PhotoService.formatContent(gptResponse.content.replaceAll('\n', ' '));

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
    final bytes = await PhotoService.captureAndConvertToJpg(contentKey);
    if (bytes != null) {
      provider.setCapturedImageBytes(bytes);
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
}

