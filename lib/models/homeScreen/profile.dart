class Profile {
  final int id;
  final String petName;
  final String imagePath;

  Profile({
    required this.id,
    required this.petName,
    required this.imagePath,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      petName: json['name'],
      imagePath: json['profileImageUrl'] ?? '', 
   );
  }
}