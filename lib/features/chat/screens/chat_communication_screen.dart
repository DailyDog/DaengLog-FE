// 외부 패키지
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
// 날짜 포맷 초기화용
// 날짜 포맷
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// 내부 패키지
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:daenglog_fe/api/diary/post/diary_create_prompt_api.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';
import 'package:daenglog_fe/features/chat/widgets/chat_gpt_photo_card.dart';
import 'package:daenglog_fe/features/chat/widgets/chat_gpt_loading_box.dart';
import 'package:daenglog_fe/shared/widgets/chat_bottom_widget.dart';
import 'package:daenglog_fe/shared/services/chat_history_storage.dart';
import 'package:daenglog_fe/features/chat/models/chat_message_model.dart';

/// 사용자로부터 텍스트와 이미지를 입력받아 GPT API에 요청하고,
/// 결과(썸네일, 키워드, 일기)를 표시하는 화면
class ChatCommunicationScreen extends StatefulWidget {
  const ChatCommunicationScreen({Key? key}) : super(key: key);

  @override
  State<ChatCommunicationScreen> createState() => _ChatCommunicationScreenState();
}

class _ChatCommunicationScreenState extends State<ChatCommunicationScreen> {
  final TextEditingController _textController = TextEditingController(); // 텍스트 입력 컨트롤러
  final ScrollController _scrollController = ScrollController(); // 스크롤 컨트롤러
  XFile? _selectedImageXFile; // 사용자가 선택한 이미지
  bool _loading = false; // 요청 진행 중 여부
  String? _error; // 에러 메시지
  final List<ChatMessageModel> _messages = []; // 채팅 메시지 리스트
  final Map<int, bool> _textVisible = {}; // 각 메시지의 텍스트 표시 여부
  final Map<int, bool> _gptMessageLoaded = {}; // GPT 메시지 로딩 완료 여부
  final DiaryCreatePromptApi _diaryCreatePromptApi = DiaryCreatePromptApi(); // API 인스턴스


  // 초기 화면 설정
  @override
  void didChangeDependencies() { // 화면 전환 시 호출되는 메서드
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;

    if (extra != null && _messages.isEmpty) {
      final prompt = extra['prompt'] as String?; // 텍스트 입력
      final image = extra['image'] as XFile?; // 이미지 선택
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
    _diaryCreatePromptApi.cancelRequest();
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
    _messages.add(ChatMessageModel.user(
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
      final profile = context.read<DefaultProfileProvider>();
      final response = await _diaryCreatePromptApi.diaryCreatePrompt(
        prompt: _textController.text,
        petId: profile.petId,
        imageFile: File(_selectedImageXFile!.path),
      );

      if (response != null) {
        final gptIndex = _messages.length;
        setState(() {
          _messages.add(ChatMessageModel.gpt(gptResponse: response));
        });
        
        // 일기 히스토리에 저장
        try {
          await ChatHistoryStorage.addDiary(response);
        } catch (e) {
          print('히스토리 저장 실패: $e');
        }
        
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
    final defaultProfile = context.watch<DefaultProfileProvider>();
    // 현재 날짜를 "YY.MM.DD(요일)" 형식으로 포맷
    final now = DateTime.now();
    final formattedDate = "${now.year % 100}.${now.month.toString().padLeft(2, '0')}.${now.day.toString().padLeft(2, '0')}(${['월','화','수','목','금','토','일'][now.weekday-1]})";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6600),
        elevation: 1,
        toolbarHeight: MediaQuery.of(context).size.height * 0.075, // 화면 높이의 7.5%
        centerTitle: true,
        title: Text(
          '${defaultProfile.petName}의 생각은..',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%
          ),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, 
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.06, // 화면 너비의 6%
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.access_time, 
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06, // 화면 너비의 6%
            ),
            onPressed: () {
              context.go('/chat_history');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.cloud_upload, 
              color: Colors.white,
              size: MediaQuery.of(context).size.width * 0.06, // 화면 너비의 6%
            ),
            onPressed: () {
              // 클라우드 아이콘 클릭 시 동작
            },
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02), // 화면 너비의 2%
        ],
      ),

      // 본문 영역: 채팅 메시지 리스트
      body: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%
          right: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%
          top: MediaQuery.of(context).size.height * 0.025, // 화면 높이의 2.5%
          bottom: MediaQuery.of(context).size.height * 0.15, // 화면 높이의 15%
        ),
        itemCount: _messages.length + 1 + (_loading ? 1 : 0), // 날짜 + 메시지 개수 + 로딩 박스
        itemBuilder: (context, idx) {
          if (idx == 0) {
            // 날짜를 맨 위에 한 번만 표시
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02), // 화면 높이의 2%
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05, // 화면 너비의 5%
                    vertical: MediaQuery.of(context).size.height * 0.01, // 화면 높이의 1%
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEDB),
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.05), // 화면 너비의 5%
                  ),
                  child: Text(
                    formattedDate,
                    style: TextStyle(
                      color: const Color(0xFFFF5F01),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.04, // 화면 너비의 4%
                    ),
                  ),
                ),
              ),
            );
          }
          final msgIdx = idx - 1;
          // 마지막 메시지 자리에 로딩 박스 표시

          if (_loading && msgIdx == _messages.length) { // 로딩 중이면 로딩 박스 표시
            return const ChatGptLoadingBox();
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
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01, // 화면 높이의 1%
                        bottom: MediaQuery.of(context).size.height * 0.005, // 화면 높이의 0.5%
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.03), // 화면 너비의 3%
                        child: Image.file(
                          File(msg.image!.path),
                          width: MediaQuery.of(context).size.width * 0.25, // 화면 너비의 25%
                          height: MediaQuery.of(context).size.width * 0.25, // 화면 너비의 25%
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (msg.text != null)
                    AnimatedOpacity(
                      opacity: _textVisible[msgIdx] == true ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01), // 화면 높이의 1%
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03), // 화면 너비의 3%
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5CC),
                          borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.04), // 화면 너비의 4%
                        ),
                        child: Text(
                          msg.text!, 
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04) // 화면 너비의 4%
                        ),
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
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.01, // 화면 높이의 1%
                  ),
                  child: ChatGptPhotoCard(
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