// 홈 화면 망고의 일주일까지 위젯
import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/chat_bottom_widget.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeTopSection extends StatefulWidget {
  const HomeTopSection({super.key});

  @override
  State<HomeTopSection> createState() => _HomeTopSectionState();
}

class _HomeTopSectionState extends State<HomeTopSection> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;
  dynamic _pickedImage;
  String? _previousRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 라우트 변경 감지
    final currentRoute = GoRouterState.of(context).uri.path;
    
    // 이전에 채팅방에 있었다가 홈으로 돌아온 경우 초기화
    if (_previousRoute != null && 
        _previousRoute == '/chat_communication' && 
        currentRoute == '/home') {
      _resetInputs();
    }
    
    _previousRoute = currentRoute;
  }

  // 입력값 초기화
  void _resetInputs() {
    if (_controller.text.isNotEmpty || _pickedImage != null) {
      setState(() {
        _controller.clear();
        _pickedImage = null;
        _error = null;
      });
    }
  }

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
    context.push(
      '/chat_communication',
      extra: {
        'prompt': text,
        'image': _pickedImage,
      },
    ).then((_) {
      // 채팅방에서 돌아왔을 때 초기화
      if (mounted) {
        _resetInputs();
      }
    });
  }

  // 채팅 서비스 취소 시 처리
  void _onCancelPressed() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<DefaultProfileProvider>();
    final profile = profileProvider.profile;

    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundImage: profile?.imagePath != null &&
                          profile!.imagePath!.isNotEmpty
                      ? NetworkImage(profile.imagePath!)
                      : AssetImage('assets/images/home/default_profile.png')
                          as ImageProvider,
                  backgroundColor: Colors.white,
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
                        text: profile?.petName != null &&
                                profile!.petName!.isNotEmpty
                            ? profile.petName
                            : 'OO',
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
    );
  }
}
