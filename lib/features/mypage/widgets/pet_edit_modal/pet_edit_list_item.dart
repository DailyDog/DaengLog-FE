import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/pet_avatar.dart';

class PetEditListItem extends StatelessWidget {
  final String name;
  final String ageText;
  final String? imageUrl;
  final bool isRepresentative;
  final bool isFamilyShared;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onTapRepresentative;

  const PetEditListItem({
    super.key,
    required this.name,
    required this.ageText,
    required this.imageUrl,
    required this.isRepresentative,
    required this.isFamilyShared,
    this.onTap,
    this.onEdit,
    this.onTapRepresentative,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: screenWidth * 0.17,
                height: screenWidth * 0.17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFADADAD), width: 1),
                ),
                child: PetAvatar(imageUrl: imageUrl, size: screenWidth * 0.17),
              ),
              if (isFamilyShared)
                Positioned(
                  right: -screenWidth * 0.01,
                  top: -screenWidth * 0.01,
                  child: Container(
                    padding: EdgeInsets.all(screenWidth * 0.008),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.group,
                      size: screenWidth * 0.045,
                      color: const Color(0xFF5C5C5C),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5C5C5C),
                          ),
                        ),
                      ),
                      Text(
                        ' | $ageText',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5C5C5C),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.008),
                      GestureDetector(
                        onTap: onEdit,
                        behavior: HitTestBehavior.opaque,
                        child: Icon(
                          Icons.edit,
                          size: screenWidth * 0.045,
                          color: const Color(0x66666666),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTapRepresentative,
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.028,
                  height: screenWidth * 0.028,
                  decoration: BoxDecoration(
                    color: isRepresentative ? const Color(0xFFFF5F01) : null,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFC4C4C4), width: 0.5),
                  ),
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  '대표',
                  style: TextStyle(
                    fontSize: screenWidth * 0.034,
                    color: const Color(0xFF5C5C5C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


