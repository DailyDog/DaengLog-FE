import 'package:flutter/material.dart';

class AddPetButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AddPetButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add, color: const Color(0xFF5C5C5C), size: screenWidth * 0.075),
            SizedBox(width: screenWidth * 0.02),
            Text('반려동물 추가', style: TextStyle(fontSize: screenWidth * 0.034, color: const Color(0xFF5C5C5C))),
          ],
        ),
      ),
    );
  }
}

class AddFamilyPetButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AddFamilyPetButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E7E7),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.add, color: const Color(0xFF5C5C5C), size: screenWidth * 0.075),
            SizedBox(width: screenWidth * 0.02),
            Text('가족 반려동물 추가', style: TextStyle(fontSize: screenWidth * 0.034, color: const Color(0xFF5C5C5C))),
          ],
        ),
      ),
    );
  }
}


