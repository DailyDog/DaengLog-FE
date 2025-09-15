import 'package:flutter/material.dart';
import 'package:daenglog_fe/api/mypage/get/my_info_api.dart';
import 'package:daenglog_fe/api/mypage/models/my_info.dart';
import 'package:daenglog_fe/shared/services/logout_service.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({super.key});

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  MyInfoModel? _myInfo;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      _myInfo = await MyInfoApi().getMyInfo();
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  String _formatBirth(String birthDate) {
    try {
      if (birthDate.isEmpty) return '';
      final parts = birthDate.split('-');
      if (parts.length != 3) return birthDate;
      final y = parts[0];
      final m = int.tryParse(parts[1]) ?? 0;
      final d = int.tryParse(parts[2]) ?? 0;
      return '${y}년 ${m}월 ${d}일';
    } catch (_) {
      return birthDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5F01),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '내 정보 관리',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pretendard',
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('불러오기 실패'))
              : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_myInfo?.name ?? ''}님, 안녕하세요!',
                        style: TextStyle(
                          fontSize: screenWidth * 0.044,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF484848),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: _providerColor(_myInfo?.provider),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // 소셜로그인 버튼
                    child: Text(
                      '${(_myInfo?.provider ?? '').isEmpty ? 'Provider' : _myInfo!.provider}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.025,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(height: 8, color: const Color(0xFFF7F7F7)),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '회원정보',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF484848),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Container(height: 1, color: const Color(0xFFEFEFEF)),
                  SizedBox(height: screenHeight * 0.02),

                  _infoRow(context, label: '이름', value: _myInfo?.name ?? ''),
                  _infoRow(context, label: '이메일', value: _myInfo?.email ?? ''),
                ],
              ),
            ),

            Container(height: 8, color: const Color(0xFFF7F7F7)),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.08,
                vertical: screenHeight * 0.014,
              ),
              child: Column(
                children: [
                  _menuItem(context, '자동 로그인 기기 설정', onTap: () {}),
                  _menuItem(context, '알림 설정', onTap: () { Navigator.pushNamed(context, '/alarm_page'); }),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Center(
              child: GestureDetector( // 이 부분 추가
                onTap: () => LogoutService.showLogoutDialog(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD4B0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Center(
              child: Column(
                children: [
                  Text(
                    '회원정보를 완전히 삭제하고 싶으신가요?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: const Color(0xFFBDBDBD),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.008,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5E5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '회원탈퇴',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9A9A9A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, {required String label, required String value}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.018),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.22,
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: const Color(0xFF9A9A9A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: const Color(0xFF484848),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, {required VoidCallback onTap}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7B7B7B),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: screenWidth * 0.04,
              color: const Color(0xFF9A9A9A),
            ),
          ],
        ),
      ),
    );
  }

  Color _providerColor(String? provider) {
    final p = (provider ?? '').toLowerCase();
    if (p == 'naver') return const Color(0xFF2DB400);
    if (p == 'google') return const Color(0xFF8A8E92);
    if (p == 'apple') return const Color(0xFF000000);
    if (p == 'kakao') return const Color(0xFFFFE300);
    return const Color(0xFF8A8E92); // default neutral
  }
}
