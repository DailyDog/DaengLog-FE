import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/utils/selectable_image.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 반응형 값 계산
    final containerPadding = screenWidth * 0.025; // 화면 너비의 2.5%
    final errorPadding = screenHeight * 0.01; // 화면 높이의 1%
    final iconSize = screenWidth * 0.06; // 화면 너비의 6%
    final fontSize = screenWidth * 0.04; // 화면 너비의 4%
    final textPadding = screenWidth * 0.03; // 화면 너비의 3%
    final bottomHeight = screenHeight * 0.05; // 화면 높이의 5%
    
    return Container(
        padding: EdgeInsets.only(
          left: containerPadding, 
          right: containerPadding, 
          bottom: containerPadding
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 컬럼 크기 조절
          children: [
            // 에러 메시지 출력
            if (widget.error != null)
              Padding(
                padding: EdgeInsets.only(bottom: errorPadding),
                child: Text(
                  widget.error!, 
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: fontSize * 0.8, // 에러 메시지는 약간 작게
                  )
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? screenWidth * 0.06), // 화면 너비의 6%
                border: Border.all(
                  color: widget.color != null ? Color(widget.color!) : const Color(0xFFFF5F01), 
                  width: widget.borderWidth ?? 1
                ),
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
                      width: iconSize,
                      height: iconSize,
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
                          ? Icon(Icons.check, size: iconSize * 0.8, color: Colors.white)
                          : SelectableImage(
                              image: widget.selectedImageXFile,
                              onImageSelected: widget.onImageSelected,
                              placeholderBuilder: () => Icon(
                                Icons.add, 
                                size: iconSize * 0.8, 
                                color: const Color.fromARGB(255, 0, 0, 0)
                              ),
                            ),
                    ),
                  ),
                  
                  // 텍스트 입력 영역
                  Expanded(
                    child: TextField(
                      controller: widget.textController,
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: fontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      enabled: !widget.loading, // 로딩 중일 때 입력 비활성화
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '방금 간식주고 찍은 사진',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: fontSize * 0.9, // 힌트 텍스트는 약간 작게
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: textPadding, 
                          vertical: textPadding
                        ),
                      ),
                    ),
                  ),
                  
                  // 전송/중단 버튼
                  IconButton(
                    onPressed: widget.loading ? _cancelRequest : _sendPrompt,
                    icon: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: widget.loading
                        ? BoxDecoration(
                            color: const Color(0xFFFF5F01), // 중단 버튼일 때
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
                          ? Icon(Icons.stop, color: Colors.white, size: iconSize * 0.8) // 중단 아이콘
                          : Icon(Icons.arrow_upward, color: Colors.black, size: iconSize * 0.7), // 전송 아이콘
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: widget.height ?? bottomHeight),
          ],
        ),
      );
  }
}