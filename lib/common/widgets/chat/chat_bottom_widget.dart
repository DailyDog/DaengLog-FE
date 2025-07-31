import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/others/selectable_image.dart';
import 'dart:async';

// 프롬프트 입력 위젯
class ChatBottomWidget extends StatefulWidget {
  final TextEditingController textController; // 텍스트 입력 컨트롤러 추가
  final dynamic selectedImageXFile; // 선택된 이미지 파일 추가
  final Function(dynamic) onImageSelected; // 이미지 선택 콜백 추가
  final VoidCallback? onSendPressed;  // 전송 버튼 콜백 추가
  final VoidCallback? onCancelPressed; // 중단 버튼 콜백 추가
  final VoidCallback? onErrorCleared; // 에러 메시지 지우기 콜백 추가
  final bool loading; // 로딩 상태 추가
  final String? error; // 에러 메시지 추가
  final int? color;
  final double? borderWidth; // 테두리 너비 추가
  final double? borderRadius; // 테두리 둥글기 추가
  final double? height; // 높이 추가
  const ChatBottomWidget({
    super.key,
    this.color,
    required this.textController,
    required this.selectedImageXFile,
    required this.onImageSelected,
    this.onSendPressed,
    this.onCancelPressed, // 중단 버튼 콜백 추가
    this.onErrorCleared,
    this.loading = false,
    this.error,
    this.borderWidth,
    this.borderRadius,
    this.height,
  });

  @override
  State<ChatBottomWidget> createState() => _ChatBottomWidgetState();
}

class _ChatBottomWidgetState extends State<ChatBottomWidget> {
  Timer? _errorTimer;

  /// 에러 메시지 타이머 초기화 함수
  @override
  void initState() {
    super.initState();
    _startErrorTimer();
  }

  /// 에러 메시지 타이머 업데이트 함수
  @override
  void didUpdateWidget(ChatBottomWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error != oldWidget.error) {
      _startErrorTimer();
    }
  }

  /// 에러 메시지 타이머 종료 함수
  @override
  void dispose() {
    _errorTimer?.cancel();
    super.dispose();
  }

  /// 에러 메시지 타이머 시작 함수
  void _startErrorTimer() {
    _errorTimer?.cancel();
    if (widget.error != null) {
      _errorTimer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          widget.onErrorCleared?.call();
        }
      });
    }
  }

  /// 전송 버튼 콜백 함수
  void _sendPrompt() {
    widget.onSendPressed?.call();
  }

  /// 중단 버튼 콜백 함수
  void _cancelRequest() {
    widget.onCancelPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 컬럼 크기 조절
          children: [
            // 에러 메시지 출력
            if (widget.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(widget.error!, style: const TextStyle(color: Colors.red)),
              ),
                          Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
                  border: Border.all(color: widget.color != null ? Color(widget.color!) : Color(0xFFFF5F01), width: widget.borderWidth ?? 1),
                ),
              child: Row(
                children: [
                  // 이미지 선택 버튼
                  IconButton(
                    onPressed: widget.loading ? null : () {
                      if (widget.selectedImageXFile != null) {
                        widget.onImageSelected(null); // 이미지 선택 함수 실행
                      }
                    },
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: widget.selectedImageXFile != null
                        ? BoxDecoration(
                            color: const Color(0xFFFF5F01),
                            shape: BoxShape.circle,
                          )
                        : BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                      child: widget.selectedImageXFile != null
                          ? const Icon(Icons.check, size: 20, color: Colors.white)
                          : SelectableImage(
                              image: widget.selectedImageXFile,
                              onImageSelected: widget.onImageSelected,
                              placeholderBuilder: () => const Icon(Icons.add, size: 20, color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                    ),
                  ),
                  
                  // 텍스트 입력 영역
                  Expanded(
                    child: TextField(
                      controller: widget.textController,
                      style: const TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      enabled: !widget.loading, // 로딩 중일 때 입력 비활성화
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: '방금 간식주고 찍은 사진',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
                  
                  // 전송/중단 버튼
                  IconButton(
                    onPressed: widget.loading ? _cancelRequest : _sendPrompt,
                    icon: Container(
                      width: 24,
                      height: 24,
                      decoration: widget.loading
                        ? BoxDecoration(
                            color: Color(0xFFFF5F01), // 중단 버튼일 때
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFFF5F01), 
                              width: 1.0,
                            ),
                          )
                        : BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                      child: widget.loading
                          ? const Icon(Icons.stop, color: Colors.white, size: 20) // 중단 아이콘
                          : const Icon(Icons.arrow_upward, color: Colors.black, size: 16), // 전송 아이콘
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.height ?? 40),
          ],
        ),
      );
  }
}