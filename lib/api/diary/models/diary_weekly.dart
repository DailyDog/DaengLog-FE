// 일주일치 일기 조회
class DiaryWeekly {
  final String? title;
  final String? date;
  final String? keyword;
  final String? imageUrl;

  DiaryWeekly({
    required this.title,
    required this.date,
    required this.keyword,
    required this.imageUrl,
  });

  factory DiaryWeekly.fromJson(Map<String, dynamic> json) {
    return DiaryWeekly(
      title: json['title'],
      date: json['date'],
      keyword: json['keyword'],
      imageUrl: json['imageUrl'],
    );
  }
}