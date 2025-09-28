import 'package:flutter/material.dart';
import 'dart:ui';

//안 보이는 듯?
class WeatherBackground extends StatelessWidget {
  const WeatherBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 좌상단 원 (블러 효과 강화)
        Positioned(
          left: -80,
          top: -20,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF8F9FA).withOpacity(0.8),
                  const Color(0xFFE9ECEF).withOpacity(0.4),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(125),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 우상단 원 (블러 효과 강화)
        Positioned(
          right: -60,
          top: 150,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF8F9FA).withOpacity(0.6),
                  const Color(0xFFE9ECEF).withOpacity(0.3),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(110),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 좌하단 원 (블러 효과 강화)
        Positioned(
          left: -40,
          bottom: 100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF8F9FA).withOpacity(0.7),
                  const Color(0xFFE9ECEF).withOpacity(0.35),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 우하단 원 (블러 효과 강화)
        Positioned(
          right: -50,
          bottom: -30,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF8F9FA).withOpacity(0.5),
                  const Color(0xFFE9ECEF).withOpacity(0.25),
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
