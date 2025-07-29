import 'dart:async';
import 'package:flutter/material.dart';

class StepProgressAnimation extends StatefulWidget {
  @override
  State<StepProgressAnimation> createState() => _StepProgressAnimationState();
}

class _StepProgressAnimationState extends State<StepProgressAnimation> {
  int _currentStep = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentStep < 2) {
          _currentStep++;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Widget> get _steps => [
    // 1단계
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, size: 80, color: Colors.orange),
        SizedBox(height: 24),
        Text('망고를 위한 페이지가\n만들어지고 있어요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 12),
            Icon(Icons.circle, color: Colors.grey, size: 12),
            Icon(Icons.circle, color: Colors.grey, size: 12),
          ],
        ),
        SizedBox(height: 24),
        Text('망고 데이터 전송 중', style: TextStyle(color: Colors.orange)),
      ],
    ),
    // 2단계
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, size: 80, color: Colors.orange),
        SizedBox(height: 24),
        Text('망고를 위한 페이지가\n만들어지고 있어요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 12),
            Icon(Icons.circle, color: Colors.orange, size: 12),
            Icon(Icons.circle, color: Colors.grey, size: 12),
          ],
        ),
        SizedBox(height: 24),
        Text('망고를 위한 페이지 제작 중', style: TextStyle(color: Colors.orange)),
        Text('망고 데이터 전송 중', style: TextStyle(color: Colors.grey)),
      ],
    ),
    // 3단계
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pets, size: 80, color: Colors.orange),
        SizedBox(height: 24),
        Text('망고를 위한 페이지가\n만들어지고 있어요.', textAlign: TextAlign.center, style: TextStyle(fontSize: 22)),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: Colors.orange, size: 12),
            Icon(Icons.circle, color: Colors.orange, size: 12),
            Icon(Icons.circle, color: Colors.orange, size: 12),
          ],
        ),
        SizedBox(height: 24),
        Text('제작 완료!', style: TextStyle(color: Colors.orange)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('망고를 위한 페이지 제작 중 ', style: TextStyle(color: Colors.grey)),
            Icon(Icons.check, color: Colors.orange, size: 18),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('망고 데이터 전송 중 ', style: TextStyle(color: Colors.grey)),
            Icon(Icons.check, color: Colors.orange, size: 18),
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        child: _steps[_currentStep],
      ),
    );
  }
}