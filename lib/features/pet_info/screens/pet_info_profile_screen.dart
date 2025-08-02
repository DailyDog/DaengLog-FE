// pet_information_profile.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';
import 'package:daenglog_fe/shared/utils/selectable_image.dart';

class PetInformationProfileScreen extends StatefulWidget {
  final void Function(XFile profileImage) onNext;
  final VoidCallback? onPrevious;
  final String? petName;
  final TextEditingController _controller = TextEditingController();
  PetInformationProfileScreen({super.key, required this.onNext, this.onPrevious, this.petName});

  @override
  State<PetInformationProfileScreen> createState() => _PetInformationProfileScreenState();
}

class _PetInformationProfileScreenState extends State<PetInformationProfileScreen> {
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      currentStep: 3,
      subject: widget.petName != null ? '${widget.petName}의 ' : '반려동물의 ',
      title: '프로필',
      titleSub: '을 올려주세요',
      subtitle: '선택사항이지만 첨부해주시면 좋아요',
      onPrevious: widget.onPrevious ?? () {
        Navigator.pop(context);
      },
      onNext: _selectedImage != null
          ? () {
              widget.onNext(_selectedImage!);
            }
          : null,
      // 이미지 선택 컴포넌트
      child: Column(
        children: [
          // 이미지 선택 컴포넌트
          SelectableImage(
            image: _selectedImage,
            onImageSelected: (img) {
              setState(() => _selectedImage = img);
            },
            // 이미지 선택 컴포넌트
            placeholderBuilder: () => Image.asset(
              'assets/images/information/camera.png',
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '이미지를 눌러서 선택하세요',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}