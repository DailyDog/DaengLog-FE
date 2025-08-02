// 디폴트 프로필 모델
class DefaultProfile {
  final int id;
  final String petName;
  final String birthDate;
  final String petGender;
  final String petSpecies;
  final String petFirstDiaryDate;
  final List<String> petPersonality;
  final int petDaysSinceFirstDiary;
  final String imagePath;

  DefaultProfile({
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

  factory DefaultProfile.fromJson(Map<String, dynamic> json) {
    return DefaultProfile(
      id: json['id'] ?? 0,
      petName: json['petName'] ?? '',
      birthDate: json['birthDate'] ?? '',
      petGender: json['petGender'] ?? '',
      petSpecies: json['petSpecies'] ?? '',
      petFirstDiaryDate: json['petFirstDiaryDate'] ?? '',
      petPersonality: List<String>.from(json['petPersonality'] ?? []),
      petDaysSinceFirstDiary: json['petDaysSinceFirstDiary'] ?? 0,
      imagePath: json['imagePath'] ?? '',
    );  
  }
}