// 과거의 반려견
class Past {
  final String imagePath;
  final String title;
  final String date;

  Past({required this.imagePath, required this.title, required this.date});

  factory Past.fromJson(Map<String, dynamic> json) {
    return Past(
      imagePath: json['imagePath'],
      title: json['title'],
      date: json['date'],
    );
  }
}
