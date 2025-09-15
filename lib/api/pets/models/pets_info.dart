class PetInfo {
  final int id;
  final String name;
  final String age;
  final bool isRepresentative;
  final String? imageUrl;

  PetInfo({
    required this.id,
    required this.name,
    required this.age,
    required this.isRepresentative,
    this.imageUrl,
  });
}