import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class PetInfoProvider extends ChangeNotifier {
  String? petKind;
  String? petName;
  DateTime? petBirthday;
  String? petGender;
  List<String>? petCharacters;
  XFile? petProfileImage;

  int currentStep = 0;

  void goToNext() {
    currentStep++;
  }

  void goToPrevious() {
    if (currentStep > 0) currentStep--;
  }

  void setPetKind(String kind) {
    petKind = kind;
    notifyListeners();
  }
  
  void setPetName(String name) {
    petName = name;
  }
  
  void setPetBirthday(DateTime birthday) {
    petBirthday = birthday;
  }

  void setPetGender(String gender) {
    petGender = gender;
  }

  void setPetCharacters(List<String> characters) {
    petCharacters = characters;
  }

  void setPetProfileImage(XFile profileImage) {
    petProfileImage = profileImage;
  }

  String? getPetKind() {
    return petKind;
  }

  String? getPetName() {
    return petName;
  }

  DateTime? getPetBirthday() {
    return petBirthday;
  }

  String? getPetGender() {
    return petGender;
  }

  List<String>? getPetCharacters() {
    return petCharacters;
  }

  XFile? getPetProfileImage() {
    return petProfileImage;
  }

  void clear() {
    petKind = null;
    petName = null;
    petBirthday = null;
    petGender = null;
    petCharacters = null;
    petProfileImage = null;
  }

  setState(Function() fn) {
    fn();
    notifyListeners();
  }
}
