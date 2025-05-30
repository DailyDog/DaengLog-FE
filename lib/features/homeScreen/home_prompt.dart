import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePromptScreen extends StatefulWidget {
  const HomePromptScreen({Key? key}) : super(key: key);

  @override
  State<HomePromptScreen> createState() => _HomePromptScreenState();
}

class _HomePromptScreenState extends State<HomePromptScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    var status = await Permission.photos.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      // 설정으로 이동 안내 다이얼로그
      bool? goToSettings = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('권한 필요'),
          content: const Text('사진을 업로드하려면 갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해 주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context, true);
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        ),
      );
      return;
    }
    // 권한 요청 (처음 요청 시 시스템 팝업 자동 표시)
    var result = await Permission.photos.request();
    if (!result.isGranted) return;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _submitPrompt() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // TODO: 사진과 텍스트를 함께 보내려면 multipart/form-data로 업로드 필요 (백엔드 명세에 따라 구현)
      // 아래는 텍스트만 전송하는 예시입니다.
      final response = await http.post(
        Uri.parse('http://localhost:8080/prompt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': text}),
      );
      // You can handle the response here if needed
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6600),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Column(
              children: [
                Image.asset(
                  'assets/images/daeng.png',
                  height: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  '오늘 망고의 기분은 어떤가요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo, color: Colors.orange),
                          onPressed: _pickImage,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'ex. 방금 간식주고 찍은 사진',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 18),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.orange),
                          onPressed: _isLoading ? null : _submitPrompt,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_pickedImage != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(_pickedImage!.path),
                      height: 100,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home_main');
                },
                child: const Text(
                  '닫기 x',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
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
