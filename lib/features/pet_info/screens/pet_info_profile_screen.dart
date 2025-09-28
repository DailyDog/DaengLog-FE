// pet_information_profile.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daenglog_fe/features/pet_info/widgets/pet_info_appbar_navbar.dart';
import 'package:daenglog_fe/shared/utils/selectable_image.dart';
import 'package:daenglog_fe/features/pet_info/providers/pet_info_provider.dart';
import 'package:daenglog_fe/api/pets/post/pet_personal_info_post_api.dart';
import 'package:daenglog_fe/api/pets/models/pets_personal_info_post_model.dart';
import 'package:provider/provider.dart';

class PetInformationProfileScreen extends StatefulWidget {
  PetInformationProfileScreen({super.key});

  @override
  State<PetInformationProfileScreen> createState() => _PetInformationProfileScreenState();
}

class _PetInformationProfileScreenState extends State<PetInformationProfileScreen> {
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return buildPetInfoScreen(
      context: context,
      currentStep: 3,
      subject: PetInfoProvider().getPetName() != null ? '${PetInfoProvider().getPetName()}의 ' : '반려동물의 ',
      title: '프로필',
      titleSub: '을 올려주세요',
      subtitle: '선택사항이지만 첨부해주시면 좋아요',
      onPrevious: () {
        Navigator.pushNamed(context, '/pet_information_character');
      },
      onNext: () async {
              final petInfo = context.read<PetInfoProvider>();

              // 선택사항이면 이 줄도 null 허용
              if (_selectedImage != null) {
                petInfo.setPetProfileImage(_selectedImage!);
              }

              try {
                await PetPersonalInfoPostApi().postPetPersonalInfo(
                  PetsPersonalInfoPostModel(
                    petKind: petInfo.getPetKind(),
                    name: petInfo.getPetName(),
                    birthday: petInfo.getPetBirthday()?.toIso8601String().split('T')[0],
                    gender: petInfo.getPetGender(),
                    characters: petInfo.getPetCharacters(),
                    // provider 대신 선택한 이미지를 직접 전달해도 OK
                    profileImage: _selectedImage,
                  ),
                );
                Navigator.pushNamed(context, '/home');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('업로드 실패: $e')),
                );
              }
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