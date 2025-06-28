// pet_information_profile.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/common/widgets/information.widgets/pet_info.dart';
import 'package:daenglog_fe/common/widgets/others/selectable_image.dart';

class PetInformationProfile extends StatefulWidget {
  const PetInformationProfile({Key? key}) : super(key: key);

  @override
  State<PetInformationProfile> createState() => _PetInformationProfileState();
}

class _PetInformationProfileState extends State<PetInformationProfile> {
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      currentStep: 2,
      title: '프로필',
      titleSub: '을 올려주세요',
      subtitle: '선택사항이지만 첨부해주시면 좋아요',
      onPrevious: () {
        Navigator.pushNamed(context, '/pet_information_character');
      },
      onNext: () {
        Navigator.pushNamed(context, '/pet_information_photo');
      },
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