// 홈 화면 망고의 일주일까지 위젯
import 'package:flutter/material.dart';
import 'package:daenglog_fe/common/widgets/chat/chat_bottom_widget.dart';

class TopSectionWidget extends StatefulWidget {
  const TopSectionWidget({super.key});

  @override
  State<TopSectionWidget> createState() => _TopSectionWidgetState();
}

class _TopSectionWidgetState extends State<TopSectionWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  dynamic _pickedImage;

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
    return Padding(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 타이틀 텍스트 (부분 강조)
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(text: '지금 '),
                    TextSpan(
                      text: '망고',
                      style: const TextStyle(color: Color(0XFFF56F01)),
                    ),
                    const TextSpan(text: '의 기분은 어떤가요?'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ChatBottomWidget으로 대체
              Container(
                color: Colors.white,
                child: ChatBottomWidget(
                  color: 0XFFFCFCFCF,
                  borderWidth: 2,
                  borderRadius: 21,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}