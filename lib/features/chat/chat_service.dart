// 외부 패키지
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // 날짜 포맷 초기화용
import 'package:intl/intl.dart'; // 날짜 포맷
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// 내부 패키지
import 'package:daenglog_fe/common/bottom/home_bottom_nav_bar.dart';
import 'package:daenglog_fe/common/widgets/others/default_profile.dart';
import 'package:daenglog_fe/common/widgets/others/selectable_image.dart';
import 'package:daenglog_fe/api/chat/create_prompt_api.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';
import 'package:daenglog_fe/common/widgets/others/gpt_photo_card_widget.dart';

/// 채팅 메시지 모델
class ChatMessage {
  final bool isUser; // true: 사용자, false: GPT
  final String? text;
  final XFile? image;
  final GptResponse? gptResponse;

  ChatMessage.user({required this.text, required this.image})
      : isUser = true, gptResponse = null;
  ChatMessage.gpt({required this.gptResponse})
      : isUser = false, text = null, image = null;
}

/// 사용자로부터 텍스트와 이미지를 입력받아 GPT API에 요청하고,
/// 결과(썸네일, 키워드, 일기)를 표시하는 화면
class ChatService extends StatefulWidget {
  const ChatService({Key? key}) : super(key: key);

  @override
  State<ChatService> createState() => _ChatServiceState();
}

class _ChatServiceState extends State<ChatService> {
  final TextEditingController _textController = TextEditingController(); // 텍스트 입력 컨트롤러
  XFile? _selectedImageXFile; // 사용자가 선택한 이미지
  bool _loading = false; // 요청 진행 중 여부
  String? _error; // 에러 메시지
  final List<ChatMessage> _messages = []; // 채팅 메시지 리스트

  /// GPT API 요청 메서드
  Future<void> _sendPrompt() async {
    if (_selectedImageXFile == null || _textController.text.isEmpty) {
      setState(() => _error = '사진과 텍스트를 모두 입력해 주세요.');
      return;
    }
    // 1. 사용자 메시지 추가
    setState(() {
      _messages.add(ChatMessage.user(
        text: _textController.text,
        image: _selectedImageXFile,
      ));
      _loading = true;
      _error = null;
    });
    try {
      final profile = context.read<DefaultProfile>();
      final response = await CreatePromptApi().createPrompt(
        prompt: _textController.text,
        petId: profile.petId,
        imageFile: File(_selectedImageXFile!.path),
      );
      // 2. GPT 메시지 추가
      setState(() {
        _messages.add(ChatMessage.gpt(gptResponse: response));
        _selectedImageXFile = null;
        _textController.clear();
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultProfile = context.watch<DefaultProfile>();
    // 현재 날짜를 "YY.MM.DD(요일)" 형식으로 포맷
    final now = DateTime.now();
    final formattedDate = "${now.year % 100}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}(${['월','화','수','목','금','토','일'][now.weekday-1]})";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        elevation: 1,
        toolbarHeight: 60,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 0), // leading 공간 확보용
            Expanded(
              child: Center(
                child: Text(
                  '${defaultProfile.petName}의 생각은..',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 40), // actions 공간 확보용
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, '/home_main'),
        ),
        actions: const [SizedBox(width: 8)],
      ),

      // 본문 영역: 채팅 메시지 리스트
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _messages.length,
        itemBuilder: (context, idx) {
          final msg = _messages[idx];
          if (msg.isUser) {
            // 사용자 메시지(사진+텍스트)
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (msg.text != null)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5CC),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (msg.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(msg.image!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(msg.text!, style: const TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
              ],
            );
          } else {
            // GPT 메시지
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GptPhotoCardWidget(
                formattedDate: formattedDate,
                gptResponse: msg.gptResponse,
              ),
            );
          }
        },
      ),

      // 입력 및 전송 영역
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 에러 메시지 출력
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 텍스트 입력 영역
                Expanded(
                  child: TextField(
                    controller: _textController,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                      hintText: 'ex. 방금 간식주고 찍은 사진',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 이미지 선택 영역
                SelectableImage(
                  image: _selectedImageXFile,
                  onImageSelected: (img) {
                    setState(() => _selectedImageXFile = img);
                  },
                  placeholderBuilder: () => Container(
                    width: 48,
                    height: 48,
                    color: Colors.grey[200],
                    child: const Icon(Icons.add_a_photo, size: 24, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),

                // 전송 버튼
                ElevatedButton(
                  onPressed: _loading ? null : _sendPrompt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.arrow_upward, color: Colors.white),
                ),
                const SizedBox(width: 12),

              ],
            ),
          ],
        ),
      ),

      // 하단 네비게이션 바
      bottomNavigationBar: commonBottomNavBar(
        context: context,
        currentIndex: 0,
      ),
    );
  }
}