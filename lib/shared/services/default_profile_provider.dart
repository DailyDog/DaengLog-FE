import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/apis/default_profile_api.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';

// 디폴트 프로필 프로바이더
class DefaultProfileProvider extends ChangeNotifier {
  
  DefaultProfile? _profile;

  // 디폴트 프로필 초기화
  DefaultProfileProvider() {
    fetchProfile();
  }

  // 디폴트 프로필 가져오기
  DefaultProfile get profile => _profile!;

  // 디폴트 프로필 가져오기
  Future<void> fetchProfile() async { // async란 비동기 처리를 위한 키워드
    try {
      _profile = await DefaultProfileApi().getDefaultProfile();
      notifyListeners();
    } catch (e) {
      print('디폴트 프로필 가져오기 실패: $e');
    }
  }

  // 디폴트 프로필 정보 가져오기 -> fetchProfile() 호출 시 자동으로 가져옴
  int? get petId => _profile?.id;
  String get petName => _profile?.petName ?? '반려동물';
  String get birthDate => _profile?.birthDate ?? '2025.01.01';
  String get petGender => _profile?.petGender ?? '남';
  String get petSpecies => _profile?.petSpecies ?? '강아지';
  String get imagePath => _profile?.imagePath ?? ''; 
  String get petFirstDiaryDate => _profile?.petFirstDiaryDate ?? '2025.01.01';
  List<String> get petPersonality => _profile?.petPersonality ?? ['활동적', '귀여운', '행복한', '착한','좋은'];
  int get petDaysSinceFirstDiary => _profile?.petDaysSinceFirstDiary ?? 0;
  int get petAge => _profile?.petAge ?? 0;
  int get ownerId => _profile?.ownerId ?? 0;
  String get ownerName => _profile?.ownerName ?? '';
  bool get isMyPet => _profile?.isMyPet ?? false;
  bool get isFamilyPet => _profile?.isFamilyPet ?? false;
  bool? get familyId => _profile?.familyId;
}