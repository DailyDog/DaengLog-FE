import 'package:daenglog_fe/models/homeScreen/profile.dart';

class GlobalProfile {
  static final GlobalProfile _instance = GlobalProfile._internal();
  factory GlobalProfile() => _instance;
  GlobalProfile._internal();

  Profile? _profile;

  // 프로필 설정
  void setProfile(Profile profile) {
    _profile = profile;
  }

  // 프로필 가져오기
  Profile? getProfile() {
    return _profile;
  }

  // 프로필 이름 가져오기
  String getPetName() {
    return _profile?.petName ?? '망고';
  }

  // 프로필 ID 가져오기
  int getPetId() {
    return _profile?.id ?? 1;
  }

  // 프로필 이미지 가져오기
  // String getProfileImage() {
  //   return _profile?.imagePath ?? 'assets/images/home/mango_image.png';
  // }

  // 프로필 초기화
  void clearProfile() {
    _profile = null;
  }
} 