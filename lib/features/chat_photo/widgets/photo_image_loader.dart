import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider_manager.dart';
import '../providers/photo_screen_provider.dart';

/// chat_photo 패키지 내에서 사용할 수 있는 예시 위젯
class PhotoImageLoader extends StatelessWidget {
  final String imageUrl;
  
  const PhotoImageLoader({
    super.key,
    required this.imageUrl,
  });
  
  @override
  Widget build(BuildContext context) {
    return PhotoProviderScope(
      child: Consumer<PhotoScreenProvider>(
        builder: (context, provider, child) {
          return ElevatedButton(
            onPressed: () {
              // chat_photo 패키지 내에서만 접근 가능!
              provider.loadNetworkImage(imageUrl);
            },
            child: Text('이미지 로드'),
          );
        },
      ),
    );
  }
}
