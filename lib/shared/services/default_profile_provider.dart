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
  Future<void> fetchProfile() async {
    // async란 비동기 처리를 위한 키워드
    try {
      _profile =
          await DefaultProfileApi().getDefaultProfile(); // API에서 프로필 가져오기
      notifyListeners(); // 프로필 변경 시 리스너 알림
    } catch (e) {
      print('디폴트 프로필 가져오기 실패: $e');

      // 인증 오류인 경우 특별 처리
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        print('인증이 필요합니다. 로그인을 다시 시도해주세요.');
        // 여기서 로그인 화면으로 이동하거나 토큰 갱신을 시도할 수 있습니다
      }

      // 프로필을 null로 설정하여 UI에서 적절히 처리할 수 있도록 함
      _profile = null;
      notifyListeners();
    }
  }

  // loadProfile 메서드 추가 (fetchProfile과 동일하지만 명시적으로 호출 가능)
  Future<void> loadProfile() async {
    await fetchProfile();
  }

  // 디폴트 프로필 정보 가져오기 -> fetchProfile() 호출 시 자동으로 가져옴
  // API에서 프로필이 없거나, 특정 필드 값이 null일 경우에도 기본값을 반환하여 안전하게 접근할 수 있도록 처리
  int? get petId => _profile?.id;
  String? get petName => _profile?.petName;
  String? get birthDate => _profile?.birthDate;
  String? get petGender => _profile?.petGender;
  String? get petSpecies => _profile?.petSpecies;
  String? get imagePath => _profile?.imagePath;
  String? get petFirstDiaryDate => _profile?.petFirstDiaryDate;
  List<String>? get petPersonality => _profile?.petPersonality;
  int? get petDaysSinceFirstDiary => _profile?.petDaysSinceFirstDiary;
  int? get petAge => _profile?.petAge;
  int? get ownerId => _profile?.ownerId;
  String? get ownerName => _profile?.ownerName;
  bool? get isMyPet => _profile?.isMyPet;
  bool? get isFamilyPet => _profile?.isFamilyPet;
  int? get familyId => _profile?.familyId;

  // 디폴트 프로필 가져오기
  DefaultProfile? get profile => _profile;
}
