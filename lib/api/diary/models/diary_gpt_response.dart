// 일기 생성 (이미지 첨부 및 프롬프트 입력)
class DiaryGptResponse {
  final int? diaryId;
  final String title;
  final String content;
  final String keyword;
  final int? recordNumber;
  final String imageUrl;
  final String date;

  DiaryGptResponse({
    required this.diaryId,
    required this.title,
    required this.content,
    required this.keyword,
    required this.recordNumber,
    required this.imageUrl,
    required this.date,
  });

  /// JSON으로부터 모델 인스턴스 생성
  factory DiaryGptResponse.fromJson(Map<String, dynamic> json) {
    return DiaryGptResponse(
      diaryId: json['diaryId'],
      title: json['title'],
      content: json['content'],
      keyword: json['keyword'],
      recordNumber: json['recordNumber'],
      imageUrl: json['imageUrl'],
      date: json['date'],
    );
  }
  
  /// JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() { //Map 함수란 키와 값의 쌍을 저장하는 자료구조, String: diaryId, dynamic: 모든 타입의 값을 저장할 수 있는 타입
    return {
      'diaryId': diaryId, 
      'title': title,
      'content': content,
      'keyword': keyword,
      'recordNumber': recordNumber,
      'imageUrl': imageUrl,
      'date': date,
    };
  }
}