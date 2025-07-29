import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/collect_info/pet_info_kind.dart';
import 'package:daenglog_fe/features/collect_info/pet_info_name.dart';
import 'package:daenglog_fe/features/collect_info/pet_info_character.dart';
import 'package:daenglog_fe/features/collect_info/pet_info_profile.dart';
import 'package:image_picker/image_picker.dart';

class PetInfoFlow extends StatefulWidget {
  @override
  State<PetInfoFlow> createState() => _PetInfoFlowState();
}

class _PetInfoFlowState extends State<PetInfoFlow> {
  int currentStep = 0;

  // 각 단계별 데이터 저장 변수 선언 (예시)
  String? petKind;
  String? petName;
  DateTime? petBirthday;
  List<String>? petCharacters;
  XFile? petProfileImage;
  String? petGender;
  void goToNext() {
    setState(() {
      currentStep++;
    });
  }

  void goToPrevious() {
    setState(() {
      if (currentStep > 0) currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 디버그: 현재 저장된 모든 데이터 출력
    print('=== PetInfoFlow Debug ===');
    print('currentStep: $currentStep');
    print('petKind: $petKind');
    print('petName: $petName');
    print('petBirthday: $petBirthday');
    print('petCharacters: $petCharacters');
    print('petProfileImage: $petProfileImage');
    print('petGender: $petGender');
    print('=======================');
    
    Widget stepWidget;
    switch (currentStep) {
      case 0:
        stepWidget = PetInformationKind(
          onNext: (kind) {
            petKind = kind;
            goToNext();
          },
        );
        print('petKind: $petKind');
        break;
      case 1:
        stepWidget = PetInformationName(
          onNext: (name, birthday, gender) {
            petName = name;
            petBirthday = birthday;
            petGender = gender;
            goToNext();
          },
        );
        print('petName: $petName, petBirthday: $petBirthday');
        break;
      case 2:
        stepWidget = PetInformationCharacter(
          petName: petName,
          onNext: (characters) {
            petCharacters = characters;
            goToNext();
          },
          onPrevious: goToPrevious,
        );
        print('petCharacters: $petCharacters');
        break;
      case 3:
        stepWidget = PetInformationProfile(
          petName: petName,
          onNext: (profileImage) {
            petProfileImage = profileImage;
            // 모든 정보가 모였으니, LoadingScreen으로 이동
            Navigator.pushReplacementNamed(
              context, 
              '/loading_screen',
              arguments: {
                'petKind': petKind,
                'petName': petName,
                'petBirthday': petBirthday,
                'petCharacters': petCharacters,
                'petProfileImage': petProfileImage,
                'petGender': petGender,
              },
            );
          },
          onPrevious: goToPrevious,
        );
        break;
      default:
        stepWidget = Center(child: Text('완료!'));
    }

    return Scaffold(
      body: SafeArea(child: stepWidget),
    );
  }
}