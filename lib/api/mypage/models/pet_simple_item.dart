class PetSimpleItem {
  final int id;
  final String name;
  final String? profileImageUrl;
  final int age;
  final bool isFamilyPet;
  final bool isDefault;

  PetSimpleItem({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.age,
    required this.isFamilyPet,
    required this.isDefault,
  });

  factory PetSimpleItem.fromJson(Map<String, dynamic> json) {
    return PetSimpleItem(
      id: json['id'] as int,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      age: (json['age'] as num).toInt(),
      isFamilyPet: json['isFamilyPet'] as bool,
      isDefault: json['isDefault'] as bool,
    );
  }
}


