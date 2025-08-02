// 홈 화면 망고의 일주일까지 위젯
import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/chat_bottom_widget.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';

class HomeTopSection extends StatefulWidget {
  const HomeTopSection({super.key, required this.profile});
  final DefaultProfile? profile;
  
  @override
  State<HomeTopSection> createState() => _HomeTopSectionState();
}

class _HomeTopSectionState extends State<HomeTopSection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  dynamic _pickedImage;

  // 이미지 선택 시 처리
  void _onImageSelected(dynamic image) {
    setState(() {
      _pickedImage = image;
    });
  }

  // 채팅 서비스로 이동
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

  // 채팅 서비스 취소 시 처리
  void _onCancelPressed() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('나야 ${widget.profile?.petName}');
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: widget.profile?.imagePath == '' ? const Color(0XFFF56F01) : Colors.white, 
                        width: 3
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 11,
                      backgroundImage: widget.profile?.imagePath != null ? NetworkImage(widget.profile!.imagePath) : null,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: '지금 '),
                        TextSpan(
                          text: widget.profile?.petName == '' ? 'OO' : widget.profile?.petName,
                          style: const TextStyle(color: Color(0XFFF56F01)),
                        ),
                        const TextSpan(text: '의 기분은 어떤가요?'),
                      ],
                    ),
                  ),  
                ],
              ),
              const SizedBox(height: 16),

              // ChatBottomWidget으로 대체
              Container(
                color: Colors.white,
                child: ChatBottomWidget(
                  color: 0XFFFCFCFCF,
                  borderWidth: 2,
                  borderRadius: 21,
                  height: 10,
                  textController: _controller,
                  selectedImageXFile: _pickedImage,
                  onImageSelected: _onImageSelected,
                  onSendPressed: _goToChatService,
                  onCancelPressed: _onCancelPressed,
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