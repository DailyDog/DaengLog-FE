// 망고의 일주일 영역
import 'package:flutter/material.dart';
import 'package:daenglog_fe/features/homeScreen/widgets/components/home_middl_photo_card.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';
import 'package:daenglog_fe/api/diary/models/diary_weekly.dart';
import 'package:daenglog_fe/api/diary/get/diary_weekly_api.dart';

class HomeMiddleSection extends StatefulWidget {
  HomeMiddleSection({super.key, required this.profile});
  final DefaultProfile? profile;

  @override
  State<HomeMiddleSection> createState() => _HomeMiddleSectionState();
}

class _HomeMiddleSectionState extends State<HomeMiddleSection> {
  @override
  Widget build(BuildContext context) {
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
                                text: widget.profile?.petName == '' ? 'OO' : widget.profile?.petName,
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
                          "일주일동안 ${widget.profile?.petName == '' ? 'OO' : widget.profile?.petName}는 어떻게 지냈을까요?",
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
                      height: 180,
                      child: FutureBuilder<List<DiaryWeekly>>( // 주간 일기 모델 api
                        future: DiaryWeeklyApi().getDiaryWeekly(petId: widget.profile?.id ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) { // 프로필이 없을 경우 등록 할 것임 이제
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
                              crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
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
                                        text: '${widget.profile?.petName == '' ? 'OO' : widget.profile?.petName}는 관심이 필요해요',
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        size: 24,
                                        color: Color(0XFF959595),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '프로필 등록하기',
                                        style: TextStyle(
                                        color: Color(0XFF959595),
                                        fontFamily: 'Pretendard',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('데이터 불러오기 실패')); // ~ 관심이 필요해요로 위에처럼 바꿀거임
                          }

                          final albums = snapshot.data!;
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: albums.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final album = albums[index];
                              return HomeMiddlePhotoCard( // 포토카드 model맞게 수정해야됨
                                imagePath: album.additionalProperties ?? '',
                                title: album.additionalProperties ?? '',
                                date: album.additionalProperties ?? '',
                              );
                            },
                          );
                        },
                      ),
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
}