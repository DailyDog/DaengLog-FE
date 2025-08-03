import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// 편지 전송 화면
class FamilySendScreen extends StatefulWidget {
  const FamilySendScreen({Key? key}) : super(key: key);

  @override
  State<FamilySendScreen> createState() => _FamilySendScreenState();
}

class _FamilySendScreenState extends State<FamilySendScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    // 애니메이션 자동 시작
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/family/send_back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie 애니메이션
            Container(
              width: 400,
              height: 400,
              child: Lottie.asset(
                'assets/images/family/send.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                onLoaded: (composition) {
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
        ),
      ),
    );
  }
}
