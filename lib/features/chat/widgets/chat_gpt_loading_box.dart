import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:provider/provider.dart';

class ChatGptLoadingBox extends StatelessWidget {
  const ChatGptLoadingBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultProfile = Provider.of<DefaultProfileProvider>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽 동그란 아이콘
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFF5F01), width: 1),
          ),
          child: Center(
            child: Image.asset(
              'assets/images/home/daeng.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // 텍스트 길이에 맞는 카드
        IntrinsicWidth(
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF5F01), width: 1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: WaveTextReveal(
              text: "${defaultProfile.petName}가 일기를 열심히 쓰고 있어요!",
              style: const TextStyle(
                fontFamily: 'Suite-SemiBold',
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              duration: const Duration(seconds: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------- WaveTextReveal ---------- */

class WaveTextReveal extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;
  const WaveTextReveal({
    required this.text,
    required this.style,
    this.duration = const Duration(seconds: 2),
    super.key,
  });

  @override
  State<WaveTextReveal> createState() => _WaveTextRevealState();
}

class _WaveTextRevealState extends State<WaveTextReveal>
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _textWidth; // ① 실제 텍스트 폭

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    // ① TextPainter로 폭 측정
    final tp = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    _textWidth = tp.width;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final waveWidth = _textWidth * 0.25;
    return Stack(
      children: [
        Text(
          widget.text,
          style: widget.style.copyWith(color: Colors.black),
          maxLines: 1,
          textAlign: TextAlign.left,
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final offset =
                (_textWidth + waveWidth) * _controller.value - waveWidth;
            return Positioned(
              left: offset,
              top: 0,
              bottom: 0,
              child: Container(
                width: waveWidth,
                height: (widget.style.fontSize ?? 14) * 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.2, 0.4],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}