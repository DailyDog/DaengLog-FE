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
    // 백엔드 응답에서 썸네일 필드명이 thumbnailUrl 인 경우도 함께 처리
    final image = json['imageUrl'] ?? json['thumbnailUrl'];

    return DiaryWeekly(
      title: json['title'],
      date: json['date'],
      keyword: json['keyword'],
      imageUrl: image,
    );
  }
}
