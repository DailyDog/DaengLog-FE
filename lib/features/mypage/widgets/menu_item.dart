import 'package:flutter/material.dart';

class MyPageMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MyPageMenuItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.018),
        // 높이와 간격을 살짝 줄임
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.014,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(color: Color(0xFFF2F2F2)),
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.09,
              height: screenWidth * 0.09,
              decoration: BoxDecoration(
                color: const Color(0xFFFDF2EA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF5F01),
                size: screenWidth * 0.048,
              ),
            ),
            SizedBox(width: screenWidth * 0.035),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.040,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF484848),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: screenWidth * 0.052,
              color: const Color(0xFF9A9A9A),
            ),
          ],
        ),
      ),
    );
  }
}
