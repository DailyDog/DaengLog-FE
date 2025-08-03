// 일주일치 일기 조회 (메인페이지용)
class DiaryWeekly {
  final String? additionalProperties;

  DiaryWeekly({
    required this.additionalProperties,
  });

  factory DiaryWeekly.fromJson(Map<String, dynamic> json) {
    return DiaryWeekly(
      additionalProperties: json['addtionalProp'],
    );
  }
}