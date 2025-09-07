class PetAllItem {
  final int id;
  final String name;
  final String? profileImageUrl;

  PetAllItem({required this.id, required this.name, required this.profileImageUrl});

  factory PetAllItem.fromJson(Map<String, dynamic> json) {
    return PetAllItem(
      id: json['id'] as int,
      name: json['name'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }
}


