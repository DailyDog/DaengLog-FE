import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/invite_option_button.dart';

/// 구성원 초대하기 메인 화면
/// 
/// 사용자가 구성원을 초대하는 방법을 선택할 수 있는 화면입니다.
/// - 초대 코드를 전송하는 옵션
/// - 받은 초대코드를 등록하는 옵션
/// 
/// Figma 디자인: 4-4-1 구성원 초대 메인
class InviteMemberMainScreen extends StatelessWidget {
  const InviteMemberMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF272727),
            size: 20,
          ),
          onPressed: () {
            // 뒤로가기
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/mypage');
            }
          },
        ),
        title: const Text(
          '구성원 초대하기',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E2E2E),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 76),
            
            // 안내 텍스트
            const Text(
              '구성원 초대 옵션을\n선택해 주세요',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 89),
            
            // 초대 코드 전송 버튼
            InviteOptionButton(
              title: '초대 코드를 전송하고 싶어요',
              isPrimary: false, // 흰색 배경, 주황색 테두리
              onTap: () {
                // 초대 코드 전송 화면으로 이동
                context.push('/invite-code-send');
              },
            ),
            
            const SizedBox(height: 24),
            
            // 초대코드 등록 버튼
            InviteOptionButton(
              title: '받은 초대코드를 등록하고 싶어요',
              isPrimary: true, // 주황색 배경, 흰색 텍스트
              onTap: () {
                // 초대코드 등록 화면으로 이동
                context.push('/invite-code-register');
              },
            ),
          ],
        ),
      ),
    );
  }
}

