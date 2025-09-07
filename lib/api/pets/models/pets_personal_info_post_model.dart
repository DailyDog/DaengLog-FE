import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class PetsPersonalInfoPostModel {
  final String? petKind;
  final String? name;
  final String? birthday;
  final String? gender;
  final List<String>? characters;
  final XFile? profileImage;

  PetsPersonalInfoPostModel({
    this.petKind,
    this.name,
    this.birthday,
    this.gender,
    this.characters,
    this.profileImage,
  });

  factory PetsPersonalInfoPostModel.fromJson(Map<String, dynamic> json) {
    return PetsPersonalInfoPostModel(
      name: json['name'],
      birthday: json['birthday'],
      gender: json['gender'],
      petKind: json['species'],
      characters: json['personalities'],
      profileImage: XFile(json['profileImage']),
    );
  }

  Map<String, dynamic> toJson() {
    final mappedGender = () {
      if (gender == null) return null;
      if (gender == '수컷' || gender == 'M') return 'M';
      if (gender == '암컷' || gender == 'F') return 'F';
      return gender; // fallback 그대로 전달
    }();

    final Map<String, dynamic> map = {
      'species': petKind,
      'name': name,
      'birthday': birthday,
      'gender': mappedGender,
      'personalities': characters ?? [],
    };
    map.removeWhere((key, value) => value == null);
    return map;
  }

  Future<FormData> toFormData() async {
    final formData = FormData();

    final requestPayload = toJson();
    formData.fields.add(MapEntry('request', jsonEncode(requestPayload)));

    if (profileImage != null) {
      formData.files.add(
        MapEntry(
          'profileImage',
          await MultipartFile.fromFile(
            profileImage!.path,
            filename: profileImage!.name,
          ),
        ),
      );
    }

    return formData;
  }
}