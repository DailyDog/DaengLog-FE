// 망고의 일주일 영역
import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/components/home_middl_photo_card.dart';
import 'package:daenglog_fe/api/diary/models/diary_weekly.dart';
import 'package:daenglog_fe/api/diary/get/diary_weekly_api.dart';
import 'package:daenglog_fe/shared/services/default_profile_provider.dart';
import 'package:provider/provider.dart';

class HomeMiddleSection extends StatefulWidget {
  const HomeMiddleSection({super.key});

  @override
  State<HomeMiddleSection> createState() => _HomeMiddleSectionState();
}

class _HomeMiddleSectionState extends State<HomeMiddleSection> {
  List<DiaryWeekly>? _weeklyDiaries;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeeklyDiaries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 프로필이 변경될 때마다 다시 로드
    _loadWeeklyDiaries();
  }

  Future<void> _loadWeeklyDiaries() async {
    final profile = context.read<DefaultProfileProvider>().profile;
    if (profile?.id == null) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final diaries =
          await DiaryWeeklyApi().getDiaryWeekly(petId: profile!.id!);

      print('홈 화면 일주일 일기 로드 완료: ${diaries.length}개');

      if (mounted) {
        setState(() {
          _weeklyDiaries = diaries;
          _isLoading = false;
          _error = null; // 성공 시 에러 상태 초기화
        });
      }
    } catch (e) {
      // 실제 네트워크 오류나 서버 오류만 에러로 처리
      print('홈 화면 일주일 일기 로드 실패: $e');
      if (mounted) {
        setState(() {
          _error = '네트워크 오류가 발생했습니다';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<DefaultProfileProvider>().profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 첫 번째 영역
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            child: Container(
              width: double.infinity,
              color: const Color(0XFFF9F9F9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: profile?.petName == null
                                    ? 'OO'
                                    : profile?.petName,
                                style: const TextStyle(
                                  color: Color(0XFFF56F01),
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                              const TextSpan(
                                text: "의 일주일",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "일주일동안 ${profile?.petName == null ? 'OO' : profile?.petName}는 어떻게 지냈을까요?",
                          style: TextStyle(
                            color: Color(0XFF959595),
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: SizedBox(
                      height: 200,
                      child: _buildWeeklyContent(profile),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyContent(dynamic profile) {
    if (profile?.id == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '텅 . .',
                  style: TextStyle(
                    color: Color(0XFF959595),
                    fontFamily: 'Yeongdeok-Sea',
                    fontSize: 40,
                  ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: '반려동물을 등록하고\n일기를 생성해 보세요',
                  style: TextStyle(
                    color: Color(0XFF959595),
                    fontFamily: 'Yeongdeok-Sea',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/pet_info');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    size: 18,
                    color: Color(0xFF5C5C5C),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '반려동물 등록',
                    style: TextStyle(
                      color: Color(0xFF5C5C5C),
                      fontFamily: 'Pretendard',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/example_screen');
            },
            child: Text(
              '가족 초대코드 입력하기',
              style: TextStyle(
                color: Color(0XFF959595),
                fontFamily: 'Pretendard',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                decorationThickness: 1.0,
                height: 2.5,
              ),
            ),
          ),
        ],
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '데이터를 불러오는데 실패했습니다',
              style: TextStyle(
                color: Color(0XFF959595),
                fontFamily: 'Pretendard',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadWeeklyDiaries,
              child: Text(
                '다시 시도',
                style: TextStyle(
                  color: Color(0xFFFF5F01),
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 데이터가 성공적으로 로드되었고 비어있지 않은 경우
    if (_weeklyDiaries != null && _weeklyDiaries!.isNotEmpty) {
      return ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _weeklyDiaries!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final album = _weeklyDiaries![index];
          return HomeMiddlePhotoCard(
            imagePath: album.imageUrl ?? '',
            title: album.title ?? '',
            date: album.date ?? '',
            keyword: album.keyword ?? '',
          );
        },
      );
    } else {
      // 데이터가 성공적으로 로드되었지만 빈 리스트인 경우 (일기가 없는 상태)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '텅 . .',
                  style: TextStyle(
                    color: Color(0XFF959595),
                    fontFamily: 'Yeongdeok-Sea',
                    fontSize: 40,
                  ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: '${profile?.petName}는 관심이 필요해요',
                  style: TextStyle(
                    color: Color(0XFF959595),
                    fontFamily: 'Yeongdeok-Sea',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
