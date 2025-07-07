// 반려견의 일주일 기록
class GptResponse {
  final int? diaryId;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String date;
  final int recordNumber;
  final String keyword;

  GptResponse({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.date,
    required this.recordNumber,
    required this.keyword,
  });

  factory GptResponse.fromJson(Map<String, dynamic> json) {
    return GptResponse(
      diaryId: json['diaryId'],
      title: json['title'],
      content: json['content'],
      thumbnailUrl: json['thumbnailUrl'],
      date: json['date'],
      recordNumber: json['recordNumber'],
      keyword: json['keyword'],
    );
  }
}