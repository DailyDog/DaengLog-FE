// 일기 상세 정보 모델
class DiaryDetail {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final String date;
  final List<String> keywords;
  final int recordNumber;
  final int petId;
  final String petName;

  DiaryDetail({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.date,
    required this.keywords,
    required this.recordNumber,
    required this.petId,
    required this.petName,
  });

  factory DiaryDetail.fromJson(Map<String, dynamic> json) {
    return DiaryDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      date: json['date'] as String,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      recordNumber: json['recordNumber'] as int,
      petId: json['petId'] as int,
      petName: json['petName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'date': date,
      'keywords': keywords,
      'recordNumber': recordNumber,
      'petId': petId,
      'petName': petName,
    };
  }
}
