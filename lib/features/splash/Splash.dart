import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // 3초 후에 /home_main으로 이동
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/onboding_start');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final logoWidth = size.width * 0.6;
    final logoHeight = size.height * 0.3;
    final logoSize = logoWidth < logoHeight ? logoWidth : logoHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash/entire.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
