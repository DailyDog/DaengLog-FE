// 디폴트 프로필 모델
class Profile {
  final int id; // 프로필 ID
  final String petName; // 프로필 이름
  final String birthDate; // 생년월일
  final String petGender; // 성별
  final String petSpecies; // 종
  final String petFirstDiaryDate; // 첫 일기 날짜
  final List<String> petPersonality; // 성격
  final int petDaysSinceFirstDiary; // 첫 일기 이후 경과 일수
  final String imagePath; // 프로필 이미지 경로

  Profile({
    required this.id,
    required this.petName,
    required this.birthDate,
    required this.petGender,
    required this.petSpecies,
    required this.petFirstDiaryDate,
    required this.petPersonality,
    required this.petDaysSinceFirstDiary,
    required this.imagePath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      petName: json['name'] ?? '', // 프로필 이름 만약 없으면 null
      birthDate: json['birthday'] ?? '', // API에서는 'birthday'
      petGender: json['gender'] ?? '',
      petSpecies: json['species'] ?? '',
      petFirstDiaryDate: json['firstDiaryDate'] ?? '',
      petPersonality: List<String>.from(json['personalities'] ?? []),
      petDaysSinceFirstDiary: json['daysSinceFirstDiary'] ?? 0,
      imagePath: json['profileImageUrl'] ?? '', 
   );
  }
}