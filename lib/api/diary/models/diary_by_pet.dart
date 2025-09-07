// 반려견별 일기 목록 응답 모델
class DiaryByPet {
  final int diaryId;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String date; // ISO yyyy-MM-dd
  final int recordNumber;
  final List<String> keywords;

  DiaryByPet({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.date,
    required this.recordNumber,
    required this.keywords,
  });

  factory DiaryByPet.fromJson(Map<String, dynamic> json) {
    return DiaryByPet(
      diaryId: json['diaryId'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      date: json['date'] as String,
      recordNumber: json['recordNumber'] as int,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
    );
  }
}


