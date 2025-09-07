import 'dart:convert';

class DiaryMonthlyCalendarModel {

  DiaryMonthlyCalendarModel({required this.calendarDays});
  
  final List<DiaryMonthlyCalendarDay> calendarDays;

  factory DiaryMonthlyCalendarModel.fromJson(Map<String, dynamic> json) {
    return DiaryMonthlyCalendarModel(
      calendarDays: (json['calendarDays'] as List? ?? [])
          .map((day) => DiaryMonthlyCalendarDay.fromJson(day as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'calendarDays': calendarDays.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class DiaryMonthlyCalendarDay {
  final String date;
  final String thumbnailImageUrl;
  final int diaryId;

  DiaryMonthlyCalendarDay({
    required this.date,
    required this.thumbnailImageUrl,
    required this.diaryId,
  });

  factory DiaryMonthlyCalendarDay.fromJson(Map<String, dynamic> json) {
    return DiaryMonthlyCalendarDay(
      date: json['date'] as String,
      thumbnailImageUrl: json['thumbnailImageUrl'] as String,
      diaryId: json['diaryId'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'thumbnailImageUrl': thumbnailImageUrl,
        'diaryId': diaryId,
      };

  @override
  String toString() => jsonEncode(toJson());
}