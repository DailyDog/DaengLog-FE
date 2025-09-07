// 디폴트 프로필 모델
class DefaultProfile {
  final int? id;
  final String? petName;
  final String? birthDate;
  final String? petGender;
  final String? petSpecies;
  final String? imagePath;
  final String? petFirstDiaryDate;
  final List<String>? petPersonality;
  final int? petDaysSinceFirstDiary;
  final int? petAge;
  final int? ownerId;
  final String? ownerName;
  final int? familyId;
  final bool isFamilyPet;
  final bool isMyPet;


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
    required this.familyId,
    required this.isFamilyPet,
    required this.isMyPet,
  });

  factory DefaultProfile.fromJson(Map<String, dynamic> json) {
    return DefaultProfile(
      id: json['id'],
      petName: json['name'],
      birthDate: json['birthday'],
      petGender: json['gender'],
      petSpecies: json['species'],
      imagePath: json['profileImageUrl'],
      petFirstDiaryDate: json['firstDiaryDate'],
      petPersonality: json['personalities'] != null 
          ? List<String>.from(json['personalities'])
          : null,
      petDaysSinceFirstDiary: json['daysSinceFirstDiary'],
      petAge: json['age'],
      ownerId: json['ownerId'],
      ownerName: json['ownerName'],
      familyId: json['familyId'],
      isFamilyPet: json['familyPet'],
      isMyPet: json['myPet'],
    );  
  }
}