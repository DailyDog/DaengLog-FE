import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/invite_code_display.dart';
import '../widgets/envelope_widget.dart';

/// 초대 코드 전송 화면
/// 
/// 초대 코드를 생성하고 카카오톡으로 전송할 수 있는 화면입니다.
/// - 초대 코드 표시 및 복사 기능
/// - 편지 봉투 디자인 표시
/// - 카카오톡 전송 버튼
/// 
/// Figma 디자인: 4-4-2 초대 코드 전송
class InviteCodeSendScreen extends StatefulWidget {
  const InviteCodeSendScreen({super.key});

  @override
  State<InviteCodeSendScreen> createState() => _InviteCodeSendScreenState();
}

class _InviteCodeSendScreenState extends State<InviteCodeSendScreen> {
  /// 초대 코드 (TODO: API에서 받아오기)
  String _inviteCode = 'EASCNE2421';

  /// 버튼 위치 추적을 위한 GlobalKey
  final GlobalKey _buttonKey = GlobalKey();

  /// 카카오톡으로 초대 코드 전송
  /// 
  /// share_plus를 사용하여 초대 코드를 카카오톡으로 공유합니다.
  /// 사용자가 카카오톡을 선택하여 메시지를 보낼 수 있습니다.
  /// 
  /// 참고: 공식 카카오톡 메시지 API를 사용하려면 Kakao SDK for Flutter 설치 필요
  /// 문서: https://developers.kakao.com/docs/latest/ko/kakaotalk-message/flutter
  Future<void> _sendInviteCodeViaKakaoTalk() async {
    try {
      // 초대 메시지 구성
      final message = '''댕댕일기 초대장이 도착했어요! 🐾

아래 초대 코드를 입력하여 가족 구성원으로 참여해주세요.

초대 코드: $_inviteCode

앱에서 초대 코드를 입력하고 우리 반려동물의 소중한 순간들을 함께 기록해요! 📸✨''';

      // iOS에서 sharePositionOrigin 에러 방지: 버튼의 위치 정보 가져오기
      Rect? sharePositionOrigin;
      final RenderBox? box = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
      
      if (box != null && box.hasSize) {
        final size = box.size;
        final offset = box.localToGlobal(Offset.zero);
        sharePositionOrigin = Rect.fromLTWH(
          offset.dx,
          offset.dy,
          size.width,
          size.height,
        );
      }

      // share_plus를 사용하여 공유
      // iOS에서는 sharePositionOrigin이 필수입니다 (특히 iPad)
      await Share.share(
        message,
        subject: '댕댕일기 초대장',
        sharePositionOrigin: sharePositionOrigin,
      );

      // 공유 완료 피드백 (선택적)
      // share_plus는 공유 다이얼로그를 열고 사용자가 선택할 수 있도록 함
      // 실제 전송 여부는 사용자가 결정하므로 별도 피드백 없음
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('전송 실패: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

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
      body: Stack(
        children: [
          // 배경 장식 원형 요소들 (선택적)
          // Figma 디자인에 있는 장식 요소들
            
          // 메인 콘텐츠
          Column(
            children: [
              const SizedBox(height: 109),
              
              // 안내 텍스트 섹션
              Column(
                children: [
                  // 메인 텍스트
                  const Text(
                    '지금 구성원에게\n초대장을 보내보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 29),
                  
                  // 서브 텍스트
                  const Text(
                    '아래 코드를 입력하여 망고 가족이 되어보세요',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFADADAD),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 초대 코드 표시
                  InviteCodeDisplay(
                    code: _inviteCode,
                    onCopy: () {
                      // 클립보드에 복사
                      Clipboard.setData(ClipboardData(text: _inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('초대 코드가 복사되었습니다'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              const Spacer(),
              
              // 편지 봉투 위젯
              const Expanded(
                child: Center(
                  child: EnvelopeWidget(),
                ),
              ),
              
              const Spacer(),
              
              // 카카오톡 전송 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  key: _buttonKey, // 버튼 위치 추적을 위한 key
                  width: double.infinity,
                  height: 57,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5F01),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Material(
                    color: Colors.transparent,
                      child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () async {
                        // 카카오톡으로 초대 코드 전송
                        await _sendInviteCodeViaKakaoTalk();
                      },
                      child: const Center(
                        child: Text(
                          '초대장 카카오톡 전송하기',
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ],
      ),
    );
  }
}

