import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  final double height;
  final Color color;
  const SectionDivider({super.key, this.height = 1, this.color = const Color(0xFFE7E7E7)});

  @override
  Widget build(BuildContext context) {
    return Container(height: height, color: color);
  }
}


