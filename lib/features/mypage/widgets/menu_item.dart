import 'package:flutter/material.dart';

class MyPageMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const MyPageMenuItem({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF484848),
              size: screenWidth * 0.05,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF484848),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.03,
              color: const Color(0xFF9A9A9A),
            ),
          ],
        ),
      ),
    );
  }
}


