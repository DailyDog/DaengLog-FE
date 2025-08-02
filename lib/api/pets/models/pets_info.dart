class PetInfo {
  final String name;
  final String age;
  final bool isRepresentative;
  final String? imageUrl;

  PetInfo({
    required this.name,
    required this.age,
    required this.isRepresentative,
    this.imageUrl,
  });
} 