import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestButtonPage(),
    );
  }
}

class TestButtonPage extends StatefulWidget {
  const TestButtonPage({super.key});

  @override
  State<TestButtonPage> createState() => _TestButtonPageState();
}

class _TestButtonPageState extends State<TestButtonPage> {
  String displayText = "버튼을 눌러주세요";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('테스트 버튼'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(displayText, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  displayText = "버튼이 눌렸습니다!";
                });
              },
              child: const Text('눌러보기'),
            ),
          ],
        ),
      ),
    );
  }
}