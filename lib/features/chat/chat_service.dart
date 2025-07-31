// 외부 패키지
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 날짜 포맷 초기화용
// 날짜 포맷
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// 내부 패키지
import 'package:daenglog_fe/common/widgets/others/default_profile.dart';
import 'package:daenglog_fe/api/diary/create_prompt_api.dart';
import 'package:daenglog_fe/models/chat/gpt_response.dart';
import 'package:daenglog_fe/common/widgets/chat/gpt_photo_card_widget.dart';
import 'package:daenglog_fe/common/widgets/chat/gpt_loading_box_widget.dart';
import 'package:daenglog_fe/common/widgets/chat/chat_bottom_widget.dart';

/// 사용자로부터 텍스트와 이미지를 입력받아 GPT API에 요청하고,
/// 결과(썸네일, 키워드, 일기)를 표시하는 화면
class ChatService extends StatefulWidget {
  const ChatService({Key? key}) : super(key: key);

  @override
  State<ChatService> createState() => _ChatServiceState();
}

class _ChatServiceState extends State<ChatService> {
  final TextEditingController _textController = TextEditingController(); // 텍스트 입력 컨트롤러
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러
  XFile? _selectedImageXFile; // 사용자가 선택한 이미지
  bool _loading = false; // 요청 진행 중 여부
  String? _error; // 에러 메시지
  final List<ChatMessage> _messages = []; // 채팅 메시지 리스트
  final Map<int, bool> _textVisible = {}; // 각 메시지의 텍스트 표시 여부
  final Map<int, bool> _gptMessageLoaded = {}; // GPT 메시지 로딩 완료 여부
  final CreatePromptApi _createPromptApi = CreatePromptApi(); // API 인스턴스

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && _messages.isEmpty) {
      final prompt = args['prompt'] as String?;
      final image = args['image'] as XFile?;
      if (prompt != null && image != null) {
        _selectedImageXFile = image;
        _textController.text = prompt;
        WidgetsBinding.instance.addPostFrameCallback((_) => _sendPrompt());
      }
    }
  }

  /// 맨 밑으로 스크롤하는 메서드
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// API 요청을 중단합니다.
  void _cancelRequest() {
    _createPromptApi.cancelRequest();
    setState(() {
      _loading = false;
      _error = null;
    });
  }

  /// GPT API 요청 메서드
  Future<void> _sendPrompt() async {
  if (_loading) return;
  if (_selectedImageXFile == null || _textController.text.isEmpty) {
    setState(() => _error = '사진과 텍스트를 모두 입력해 주세요.');
    return;
  }

  // 사용자 메시지 추가
  setState(() {
    _messages.add(ChatMessage.user(
      text: _textController.text,
      image: _selectedImageXFile,
    ));
  });

  final messageIndex = _messages.length - 1;

  // 즉시 로딩 상태 on
  setState(() {
    _loading = true;
  });
  _scrollToBottom();

  // 텍스트 표시 → 그 이후 0.5초 대기
  Future.delayed(const Duration(milliseconds: 0), () async {
    if (!mounted) return;
    setState(() {
      _textVisible[messageIndex] = true;
    });
    _scrollToBottom();

    try {
      final profile = context.read<DefaultProfile>();
      final response = await _createPromptApi.createPrompt(
        prompt: _textController.text,
        petId: profile.petId,
        imageFile: File(_selectedImageXFile!.path),
      );

      if (response != null) {
        final gptIndex = _messages.length;
        setState(() {
          _messages.add(ChatMessage.gpt(gptResponse: response));
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;

          // 로딩 완료 표시
          setState(() => _gptMessageLoaded[gptIndex] = true);

          // 입력 필드 바로 지우기
          setState(() {
            _selectedImageXFile = null;
            _textController.clear();
            _error = null;
          });
          _scrollToBottom();
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  });

  _scrollToBottom();
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [SizedBox(width: 8)],
      ),

      // 본문 영역: 채팅 메시지 리스트
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
        itemCount: _messages.length + 1 + (_loading ? 1 : 0), // 날짜 + 메시지 개수 + 로딩 박스
        itemBuilder: (context, idx) {
          if (idx == 0) {
            // 날짜를 맨 위에 한 번만 표시
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEDB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFFFF5F01),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
          }
          final msgIdx = idx - 1;
          // 마지막 메시지 자리에 로딩 박스 표시

          if (_loading && msgIdx == _messages.length) { // 로딩 중이면 로딩 박스 표시
            return const GptLoadingBoxWidget();
          }

          // 메시지 렌더링
          if (msgIdx < _messages.length) {
            final msg = _messages[msgIdx];
            if (msg.isUser) {
              // 사용자 메시지(사진+텍스트)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (msg.image != null)
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(msg.image!.path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (msg.text != null)
                    AnimatedOpacity(
                      opacity: _textVisible[msgIdx] == true ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5CC),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(msg.text!, style: const TextStyle(fontSize: 15)),
                      ),
                    ),
                ],
              );
            } else {
              // GPT 메시지
              return AnimatedOpacity(
                opacity: _gptMessageLoaded[msgIdx] == true ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: GptPhotoCardWidget(
                    formattedDate: formattedDate,
                    gptResponse: msg.gptResponse,
                  ),
                ),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
//--------------------------------- 하단 네비게이션 바 위 영역 --------------------------------- 
      // 입력 및 전송 영역
      bottomSheet: ChatBottomWidget(
        color: 0XFFF56F01,
        textController: _textController,
        selectedImageXFile: _selectedImageXFile,
        onImageSelected: (img) {
          setState(() => _selectedImageXFile = img);
        },
        onSendPressed: _sendPrompt,
        onCancelPressed: _cancelRequest, // 중단 콜백 추가
        onErrorCleared: () {
          setState(() => _error = null);
        },
        loading: _loading,
        error: _error,
      ),
    );
  }
}

/// 채팅 메시지 모델
class ChatMessage {
  final bool isUser; // true: 사용자, false: GPT
  final String? text;
  final XFile? image;
  final GptResponse? gptResponse;

  /// 사용자 메시지
  ChatMessage.user({required this.text, required this.image})
      : isUser = true, gptResponse = null;
  /// GPT 메시지
  ChatMessage.gpt({required this.gptResponse})
      : isUser = false, text = null, image = null;
}