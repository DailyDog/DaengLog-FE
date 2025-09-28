import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_kind_screen.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_name_screen.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_character_screen.dart';
import 'package:daenglog_fe/features/pet_info/screens/pet_info_profile_screen.dart';
import 'package:daenglog_fe/features/pet_info/providers/pet_info_provider.dart';
import 'package:daenglog_fe/api/pets/post/pet_personal_info_post_api.dart';
import 'package:daenglog_fe/api/pets/models/pets_personal_info_post_model.dart';

// 반려동물 정보 입력 화면 모음(종류, 이름, 성격, 프로필)
class PetInfoScreen extends StatefulWidget {
  @override
  State<PetInfoScreen> createState() => _PetInfoScreenState();
}

class _PetInfoScreenState extends State<PetInfoScreen> {

  @override
  Widget build(BuildContext context) {
    
    Widget stepWidget = const SizedBox.shrink();
    switch (PetInfoProvider().currentStep) {
      case 0:
        stepWidget = PetInformationKindScreen();
        final petKind = PetInfoProvider().getPetKind();
        if (petKind != null) {
          PetInfoProvider().goToNext();
        }
        break;
      case 1:
        stepWidget = PetInformationNameScreen();
        final petName = PetInfoProvider().getPetName();
        final petBirthday = PetInfoProvider().getPetBirthday();
        final petGender = PetInfoProvider().getPetGender();
        if (petName != null && petBirthday != null && petGender != null) {
          PetInfoProvider().goToNext();
        }
        break;
      case 2:
        stepWidget = PetInformationCharacterScreen();
        final petCharacters = PetInfoProvider().getPetCharacters();
        if (petCharacters != null) {
          PetInfoProvider().goToNext();
        }
        break;
      case 3:
        stepWidget = PetInformationProfileScreen();
        final petProfileImage = PetInfoProvider().getPetProfileImage();
        if (petProfileImage != null) {
          PetInfoProvider().goToNext();
        }
        break;
      case 4:
        PetPersonalInfoPostApi().postPetPersonalInfo(PetsPersonalInfoPostModel(
          petKind: PetInfoProvider().getPetKind(),
          name: PetInfoProvider().getPetName(),
          birthday: PetInfoProvider().getPetBirthday()?.toIso8601String().split('T')[0],
          gender: PetInfoProvider().getPetGender(),
          characters: PetInfoProvider().getPetCharacters(),
          profileImage: PetInfoProvider().getPetProfileImage(),
        ));
        // 홈화면으로 이동
        context.go('/home');
        break;

      default:
        stepWidget = Center(child: Text('완료!'));
    }

    return Scaffold(
      body: SafeArea(child: stepWidget),
    );
  }
}