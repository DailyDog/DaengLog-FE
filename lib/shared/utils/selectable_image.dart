import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectableImage extends StatelessWidget {
  final XFile? image;
  final void Function(XFile image) onImageSelected;
  final Widget Function()? placeholderBuilder;

  const SelectableImage({
    super.key,
    required this.image,
    required this.onImageSelected,
    this.placeholderBuilder,
  });

  Future<void> _pickImage(BuildContext context) async {
    final permission = Platform.isIOS ? Permission.photos : Permission.storage;

    // 권한 요청
    final status = await permission.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        onImageSelected(picked);
      }
    } else if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      // 권한 거부 시 안내 다이얼로그
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('권한 필요'),
          content: const Text('이미지를 선택하려면 갤러리 접근 권한이 필요합니다. 설정에서 권한을 허용해 주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('설정으로 이동'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImage(context),
      child: image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(image!.path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            )
          : (placeholderBuilder != null
              ? placeholderBuilder!()
              : Image.asset(
                  'assets/images/information/camera.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                )),
    );
  }
}
