import 'package:flutter/material.dart';

// 마켓 화면
class Close extends StatelessWidget {
  const Close({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home_main');
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: const Center(child: Text('Close')),
    );
  }
}
