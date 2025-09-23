class MyPageSummary {
  final int userId;
  final String userName;
  final String planCode;
  final String planName;
  final PetSummary defaultPet;
  final List<PetSummary> myPets;
  final int totalPetCount;

  MyPageSummary({
    required this.userId,
    required this.userName,
    required this.planCode,
    required this.planName,
    required this.defaultPet,
    required this.myPets,
    required this.totalPetCount,
  });

  factory MyPageSummary.fromJson(Map<String, dynamic> json) {
    return MyPageSummary(
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      planCode: json['planCode'] as String,
      planName: json['planName'] as String,
      defaultPet: PetSummary.fromJson(json['defaultPet'] as Map<String, dynamic>),
      myPets: ((json['myPets'] as List?) ?? const [])
          .map((e) => PetSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPetCount: json['totalPetCount'] as int,
    );
  }
}

class PetSummary {
  final int id;
  final String name;
  final String? profileImageUrl;
  final int age;
  final bool isDefault;

  PetSummary({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.age,
    required this.isDefault,
  });

  factory PetSummary.fromJson(Map<String, dynamic> json) {
    return PetSummary(
      id: json['id'] as int,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      age: (json['age'] as num).toInt(),
      isDefault: json['isDefault'] as bool,
    );
  }
}


