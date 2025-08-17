// 반려동물별 앨범 목록 조회
class AlbumDiary {
  final int? diaryId;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String date;
  final int recordNumber;
  final String keyword;

  AlbumDiary({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.date,
    required this.recordNumber,
    required this.keyword,
  });

  factory AlbumDiary.fromJson(Map<String, dynamic> json) {
    return AlbumDiary(
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