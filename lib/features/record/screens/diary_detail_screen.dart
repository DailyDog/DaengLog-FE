import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/diary/get/diary_by_pet_api.dart';
import 'package:daenglog_fe/api/diary/models/diary_by_pet.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:daenglog_fe/features/record/screens/diary_photo_cards_screen.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int diaryId;

  const DiaryDetailScreen({super.key, required this.diaryId});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  List<DiaryByPet>? _diaries;
  bool _isLoading = true;
  String? _error;
  int _initialPage = 0;

  @override
  void initState() {
    super.initState();
    _loadDiary();
  }

  Future<void> _loadDiary() async {
    try {
      final profileProvider = Provider.of<DefaultProfileProvider>(context, listen: false);
      final profile = profileProvider.profile;
      
      if (profile == null || profile.id == null) {
        setState(() {
          _error = '프로필을 불러올 수 없습니다.';
          _isLoading = false;
        });
        return;
      }

      // 해당 반려동물의 모든 일기를 가져옴
      final allDiaries = await DiaryByPetApi().getDiaryByPet(petId: profile.id!);
      
      // diaryId로 필터링하여 해당 일기 찾기
      final targetDiary = allDiaries.firstWhere(
        (diary) => diary.diaryId == widget.diaryId,
        orElse: () => throw Exception('일기를 찾을 수 없습니다.'),
      );

      // 같은 날짜의 일기들만 필터링
      final sameDateDiaries = allDiaries
          .where((diary) => diary.date == targetDiary.date)
          .toList()
        ..sort((a, b) => b.recordNumber.compareTo(a.recordNumber)); // recordNumber 내림차순 정렬

      // 클릭한 일기의 인덱스 찾기
      final targetIndex = sameDateDiaries.indexWhere(
        (diary) => diary.diaryId == widget.diaryId,
      );
      final initialPage = targetIndex >= 0 ? targetIndex : 0;

      if (mounted) {
        setState(() {
          _diaries = sameDateDiaries;
          _initialPage = initialPage;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('일기'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null || _diaries == null || _diaries!.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('일기'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error ?? '일기를 불러올 수 없습니다.',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _loadDiary();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return DiaryPhotoCardsScreen(
      diaries: _diaries!,
      initialPage: _initialPage,
    );
  }
}

