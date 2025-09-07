import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/utils/image_utils.dart';

class PetAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final double? borderWidth;
  final Color? borderColor;
  final String fallbackAsset;

  const PetAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.borderWidth,
    this.borderColor,
    this.fallbackAsset = 'assets/images/home/default_profile.png',
  });

  @override
  Widget build(BuildContext context) {
    final sanitized = ImageUtils.sanitizePresignedUrl(imageUrl);
    final avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.white,
      child: ClipOval(
        child: (sanitized != null && sanitized.isNotEmpty)
            ? Image.network(
                sanitized,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  fallbackAsset,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                fallbackAsset,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
      ),
    );

    if (borderWidth != null && borderColor != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor!, width: borderWidth!),
        ),
        child: avatar,
      );
    }
    return SizedBox(width: size, height: size, child: avatar);
  }
}


