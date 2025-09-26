import 'package:flutter/material.dart';

class WeatherAppBar extends StatelessWidget {
  final String location;
  final VoidCallback onBackPressed;

  const WeatherAppBar({
    super.key,
    required this.location,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackPressed,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(
                Icons.arrow_back_ios,
                size: 17,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
          Expanded(
            child: Text(
              location,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 36), // 백 버튼과 대칭을 맞추기 위한 여백
        ],
      ),
    );
  }
}
