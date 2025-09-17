import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:daenglog_fe/shared/widgets/bottom_nav_bar.dart';
import 'package:daenglog_fe/features/mypage/widgets/pet_edit_modal.dart';
import 'package:daenglog_fe/api/pets/models/pets_info.dart';
import 'package:daenglog_fe/shared/apis/default_profile_api.dart';
import 'package:daenglog_fe/shared/models/default_profile.dart';

class MyPageMainScreen extends StatefulWidget {
  const MyPageMainScreen({super.key});

  @override
  State<MyPageMainScreen> createState() => _MyPageMainScreenState();
}

class _MyPageMainScreenState extends State<MyPageMainScreen> {
  // ----- state -----
  bool _showPetEditModal = false;
  final List<PetInfo> _pets = [
    PetInfo(name: '망고', age: '10살', isRepresentative: true),
    PetInfo(name: '나비', age: '7살', isRepresentative: false),
    PetInfo(name: '미등록', age: '0살', isRepresentative: false),
  ];
  int _representativeIndex = 0;

  DefaultProfile? _profile;
  bool _isLoadingProfile = false;

  // scroll
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  // ----- lifecycle -----
  @override
  void initState() {
    super.initState();
    _fetchProfile();

    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoadingProfile = true);
    try {
      final prof = await DefaultProfileApi().getDefaultProfile();
      setState(() => _profile = prof);
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  bool get _hasFamilyService {
    final p = _profile;
    if (p == null) return false;
    try {
      final dynamic d = p;
      if (d.familyServiceEnabled == true) return true;
      if (d.hasFamilyService == true) return true;
      if (d.familyId != null) return true;
      if (d.groupId != null) return true;
      final planType = (d.planType ?? d.plan_name ?? d.planName)?.toString();
      if (planType != null && planType.contains('가족')) return true;
    } catch (_) {}
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final topSafe = mq.padding.top;

    // 레이아웃 값들
    const double headerHeight = 300;
    final double avatar = w * 0.27;
    final double sheetTopSpacer = headerHeight - 145;
    final double petThumb = w * 0.18;

    // 스크롤에 따른 헤더 스크림
    final double scrimOpacity = (math.min(_scrollOffset, 120) / 120) * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      bottomNavigationBar: commonBottomNavBar(context: context, currentIndex: 3),

      body: Stack(
        children: [
          // 1) 고정 주황 배경
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  height: headerHeight + topSafe,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5F01),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),

          // 2) 고정 헤더(프로필/그리팅/설정)
          Positioned(
            top: topSafe, left: 0, right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 아바타
                  Stack(
                    children: [
                      Container(
                        width: avatar,
                        height: avatar,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Icon(Icons.person,
                            size: avatar * 0.48,
                            color: const Color(0xFF666666)),
                      ),
                      Positioned(
                        right: 6, bottom: 6,
                        child: Container(
                          width: avatar * 0.22,
                          height: avatar * 0.22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5F01),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt,
                              size: avatar * 0.14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 26),

                  // 텍스트 영역
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _GreetingText(),
                        SizedBox(height: 11),
                        _PlanBadge(),
                      ],
                    ),
                  ),

                  // 설정
                  Transform.translate(
                    offset: const Offset(0, -8),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3) 스크롤 시트(흰 프레임)
          Positioned.fill(
            child: SafeArea(
              top: false,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // 헤더 높이만큼 spacer
                  SliverToBoxAdapter(child: SizedBox(height: sheetTopSpacer + topSafe)),

                  SliverToBoxAdapter(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Column(
                        children: [
                          // “내 반려동물”
                          Padding(
                            padding: const EdgeInsets.fromLTRB(35, 25, 35, 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 타이틀 + 수정
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '내 반려동물',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF484848),
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => setState(() => _showPetEditModal = true),
                                      child: Row(
                                        children: const [
                                          Text(
                                            '수정',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF9A9A9A),
                                              fontFamily: 'Pretendard',
                                            ),
                                          ),
                                          SizedBox(width: 2),
                                          Icon(Icons.chevron_right,
                                              size: 18, color: Color(0xFF9A9A9A)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Pretendard',
                                      color: Color(0xFF9A9A9A),
                                    ),
                                    children: [
                                      TextSpan(text: '반려동물 선택 시 '),
                                      TextSpan(
                                          text: '대표 반려동물',
                                          style: TextStyle(color: Color(0xFFFF5F01))),
                                      TextSpan(text: '로 설정됩니다.'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 썸네일 가로 스크롤
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: _pets.asMap().entries.map((e) {
                                      final index = e.key;
                                      final pet = e.value;
                                      final selected = index == _representativeIndex;

                                      return Padding(
                                        padding: EdgeInsets.only(right: w * 0.06),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: petThumb,
                                              height: petThumb,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: selected
                                                      ? const Color(0xFFFF5F01)
                                                      : const Color(0xFFE0E0E0),
                                                  width: 2,
                                                ),
                                                boxShadow: selected
                                                    ? [
                                                        BoxShadow(
                                                          color: const Color(0xFFFF5F01)
                                                              .withOpacity(0.25),
                                                          blurRadius: 10,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ]
                                                    : [],
                                              ),
                                              child: Icon(
                                                Icons.pets,
                                                size: petThumb * 0.5,
                                                color: selected
                                                    ? const Color(0xFFFF5F01)
                                                    : const Color(0xFF9A9A9A),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              pet.name,
                                              style: TextStyle(
                                                fontSize: w * 0.032,
                                                fontWeight: selected
                                                    ? FontWeight.w700
                                                    : FontWeight.w500,
                                                color: selected
                                                    ? const Color(0xFF2D2D2D)
                                                    : const Color(0xFF9A9A9A),
                                                fontFamily: 'Pretendard',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 회색 분리선
                          Container(height: 8, color: const Color(0xFFF3F3F3)),

                          // 메뉴 리스트 카드
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: const [
                                  _MenuItem(title: '내정보 관리', route: '/my_info_page', icon: Icons.person_outline),
                                  _Divider(),
                                  _MenuItem(title: '이벤트/혜택', route: '/event', icon: Icons.card_giftcard_outlined),
                                  _Divider(),
                                  _MenuItem(title: '요금제 관리', route: '/cloud_main', icon: Icons.payment_outlined),
                                  _Divider(),
                                  _MenuItem(title: '공지사항', route: '/notice', icon: Icons.announcement_outlined),
                                  _Divider(),
                                  _MenuItem(title: '고객센터', route: '/customer_center', icon: Icons.help_outline),
                                ],
                              ),
                            ),
                          ),

                          // 로그아웃 + 버전
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                            child: Column(
                              children: const [
                                _LogoutButton(),
                                SizedBox(height: 12),
                                Text(
                                  'Ver 1.01',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFBBBBBB),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4) 헤더용 스크림(스크롤 시 어두워지며 글씨 흐려지는 느낌)
          Positioned(
            top: 0, left: 0, right: 0,
            height: headerHeight + topSafe,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(scrimOpacity * 0.65),
                      Colors.black.withOpacity(scrimOpacity * 0.25),
                      Colors.black.withOpacity(0),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 로딩
          if (_isLoadingProfile)
            const IgnorePointer(
              ignoring: true,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFF5F01)),
              ),
            ),

          // 모달
          if (_showPetEditModal)
            PetEditModal(
              pets: _pets,
              representativeIndex: _representativeIndex,
              hasFamilyService: _hasFamilyService,
              onClose: () => setState(() => _showPetEditModal = false),
              onAddPet: () {},
              onAddFamilyPet: () {},
              onSelectPet: (pet) {
                setState(() {
                  _representativeIndex = _pets.indexOf(pet as PetInfo);
                  _showPetEditModal = false;
                });
              },
            ),
        ],
      ),
    );
  }
}

// ───────── 작은 위젯들 ─────────

class _MenuItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  const _MenuItem({required this.title, required this.route, required this.icon});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: w * 0.04),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2D2D2D), size: w * 0.055),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: w * 0.042,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D2D2D),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFBBBBBB)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0xFFF0F0F0), margin: const EdgeInsets.symmetric(horizontal: 16));
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE8D6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFF5F01).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Center(
        child: Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF5F01),
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText();
  @override
  Widget build(BuildContext context) {
    return const Text(
      '망고 집사님,\n안녕하세요!',
      softWrap: true,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontFamily: 'Pretendard',
        height: 1.3,
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  const _PlanBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Text(
        '댕가족 플랜',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFFFF5F01),
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}