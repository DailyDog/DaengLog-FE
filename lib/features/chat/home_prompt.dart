import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/common/widgets/chat/chat_bottom_widget.dart';

class HomePromptScreen extends StatefulWidget {
  const HomePromptScreen({Key? key}) : super(key: key);

  @override
  State<HomePromptScreen> createState() => _HomePromptScreenState();
}

class _HomePromptScreenState extends State<HomePromptScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  XFile? _pickedImage;

  void _onImageSelected(dynamic image) {
    setState(() {
      _pickedImage = image;
    });
  }

  void _goToChatService() {
    final text = _controller.text.trim();
    if (text.isEmpty || _pickedImage == null) return;
    Navigator.pushNamed(
      context,
      '/chat_service',
      arguments: {
        'prompt': text,
        'image': _pickedImage,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                Image.asset(
                  'assets/images/home/daeng.png',
                  height: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  '오늘 반려동물의 기분은 어떤가요?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    color: Colors.white,
                    child: ChatBottomWidget(
                      color: 0XFFF56F01,
                      textController: _controller,
                      selectedImageXFile: _pickedImage,
                      onImageSelected: _onImageSelected,
                      onSendPressed: _goToChatService,
                      onCancelPressed: () {
                        // 중단 콜백 추가
                      },
                      onErrorCleared: () {
                        setState(() => _error = null);
                      },
                      loading: _loading,
                      error: _error,
                    ),
                  )
                ),
                
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// [Android 권한 설정]
// android/app/src/main/AndroidManifest.xml에 아래 추가:
// <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
// <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
//
// [iOS 권한 설정]
// ios/Runner/Info.plist에 아래 추가:
// <key>NSPhotoLibraryUsageDescription</key>
// <string>사진을 업로드하기 위해 갤러리 접근 권한이 필요합니다.</string>