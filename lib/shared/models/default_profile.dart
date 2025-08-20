// 디폴트 프로필 모델
class DefaultProfile {
  final int id;
  final String petName;
  final String birthDate;
  final String petGender;
  final String petSpecies;
  final String imagePath;
  final String petFirstDiaryDate;
  final List<String> petPersonality;
  final int petDaysSinceFirstDiary;
  final int petAge;
  final int ownerId;
  final String ownerName;
  final bool isMyPet;
  final bool isFamilyPet;
  final bool? familyId;


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
    required this.petAge,
    required this.ownerId,
    required this.ownerName,
    required this.isMyPet,
    required this.isFamilyPet,
    required this.familyId,
  });

  factory DefaultProfile.fromJson(Map<String, dynamic> json) {
    return DefaultProfile(
      id: json['id'] ?? 0,
      petName: json['name'] ?? '',
      birthDate: json['birthDate'] ?? '',
      petGender: json['gender'] ?? '',
      petSpecies: json['species'] ?? '',
      imagePath: json['profileImageUrl'] ?? '',
      petFirstDiaryDate: json['firstDiaryDate'] ?? '',
      petPersonality: List<String>.from(json['personality'] ?? []),
      petDaysSinceFirstDiary: json['daysSinceFirstDiary'] ?? 0,
      petAge: json['age'] ?? 0,
      ownerId: json['ownerId'] ?? 0,
      ownerName: json['ownerName'] ?? '',
      isMyPet: json['isMyPet'] ?? false,
      isFamilyPet: json['isFamilyPet'] ?? false,
      familyId: json['familyId'] ?? null,
    );  
  }
}