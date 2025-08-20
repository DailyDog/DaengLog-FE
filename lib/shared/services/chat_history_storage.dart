import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daenglog_fe/api/diary/models/diary_gpt_response.dart';

class ChatHistoryStorage {
  static const String _key = 'chat_history';
  
  /// 일기 히스토리에 새로운 일기 추가
  static Future<void> addDiary(DiaryGptResponse diary) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    
    // 현재 시간을 포함한 일기 데이터 생성
    final diaryWithTimestamp = {
      ...diary.toJson(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };
    
    history.add(jsonEncode(diaryWithTimestamp));
    
    // 24시간이 지난 일기들 제거
    final cleanedHistory = _removeExpiredDiaries(history);
    
    await prefs.setStringList(_key, cleanedHistory);
  }
  
  /// 24시간이 지난 일기들 제거
  static List<String> _removeExpiredDiaries(List<String> history) {
    final now = DateTime.now();
    final List<String> validHistory = [];
    
    for (final diaryJson in history) {
      try {
        final diaryData = jsonDecode(diaryJson);
        final createdAt = DateTime.fromMillisecondsSinceEpoch(diaryData['createdAt']);
        
        // 24시간 이내인지 확인
        if (now.difference(createdAt).inHours < 24) {
          validHistory.add(diaryJson);
        }
      } catch (e) {
        // 잘못된 데이터는 제거
        continue;
      }
    }
    
    return validHistory;
  }
  
  /// 24시간 이내의 모든 일기 가져오기
  static Future<List<DiaryGptResponse>> getRecentDiaries() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_key) ?? [];
    
    // 24시간이 지난 일기들 제거하고 유효한 일기들만 반환
    final cleanedHistory = _removeExpiredDiaries(history);
    
    // 업데이트된 히스토리 저장
    if (cleanedHistory.length != history.length) {
      await prefs.setStringList(_key, cleanedHistory);
    }
    
    final List<DiaryGptResponse> diaries = [];
    
    for (final diaryJson in cleanedHistory) {
      try {
        final diaryData = jsonDecode(diaryJson);
        // createdAt 필드 제거하고 DiaryGptResponse 생성
        diaryData.remove('createdAt');
        diaries.add(DiaryGptResponse.fromJson(diaryData));
      } catch (e) {
        continue;
      }
    }
    
    // 최신 순으로 정렬
    diaries.sort((a, b) => b.recordNumber?.compareTo(a.recordNumber ?? 0) ?? 0);
    
    return diaries;
  }
  
  /// 모든 일기 히스토리 삭제
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
