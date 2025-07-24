// 반려견의 일주일 기록
class GptResponse {
  final int? diaryId;
  final String title;
  final String content;
  final String keyword;
  final int recordNumber;
  final String imageUrl;
  final String date;

  GptResponse({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.keyword,
    required this.recordNumber,
    required this.imageUrl,
    required this.date,
  });

  factory GptResponse.fromJson(Map<String, dynamic> json) {
    return GptResponse(
      diaryId: json['diaryId'],
      title: json['title'],
      content: json['content'],
      keyword: json['keyword'],
      recordNumber: json['recordNumber'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }
}