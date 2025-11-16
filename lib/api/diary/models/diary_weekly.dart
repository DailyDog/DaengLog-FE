class DiaryWeekly {
  final int? diaryId;
  final String? title;
  final String? date;
  final String? keyword;
  final String? imageUrl;

  DiaryWeekly({
    required this.diaryId,
    required this.title,
    required this.date,
    required this.keyword,
    required this.imageUrl,
  });

  factory DiaryWeekly.fromJson(Map<String, dynamic> json) {
    // 백엔드 응답에서 썸네일 필드명이 thumbnailUrl 인 경우도 함께 처리
    final image = json['imageUrl'] ?? json['thumbnailUrl'];

    return DiaryWeekly(
      diaryId: (json['diaryId'] as num?)?.toInt(),
      title: json['title'],
      date: json['date'],
      keyword: json['keyword'],
      imageUrl: image,
    );
  }
}

// 주간 일기 + 통계 응답 래퍼
class DiaryWeeklySummary {
  final List<DiaryWeekly> diaries;
  final int todayCount;
  final int weeklyCount;

  DiaryWeeklySummary({
    required this.diaries,
    required this.todayCount,
    required this.weeklyCount,
  });
}
