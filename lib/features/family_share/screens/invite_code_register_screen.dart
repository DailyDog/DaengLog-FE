import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/invite_code_input_field.dart';

/// 초대 코드 입력 화면
/// 
/// 받은 초대 코드를 입력하여 가족 구성원으로 참여하는 화면입니다.
/// - 초대 코드 입력 필드
/// - 코드 유효성 검사
/// - 도움말 텍스트
/// - 다음 버튼
/// 
/// Figma 디자인: 4-4-3 초대 코드 입력
class InviteCodeRegisterScreen extends StatefulWidget {
  const InviteCodeRegisterScreen({super.key});

  @override
  State<InviteCodeRegisterScreen> createState() => _InviteCodeRegisterScreenState();
}

class _InviteCodeRegisterScreenState extends State<InviteCodeRegisterScreen> {
  /// 초대 코드 입력 컨트롤러
  final TextEditingController _codeController = TextEditingController();
  
  /// 코드 입력이 유효한지 여부
  bool _isCodeValid = false;
  
  @override
  void initState() {
    super.initState();
    _codeController.addListener(_validateCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// 코드 유효성 검사
  /// TODO: 실제 API 연결 시 서버에서 검증
  void _validateCode() {
    final code = _codeController.text.trim();
    // 기본 검증: 10자 이상이고 영문자/숫자만 포함
    final isValid = code.length >= 10 && 
                    RegExp(r'^[A-Z0-9]+$').hasMatch(code);
    
    if (_isCodeValid != isValid) {
      setState(() {
        _isCodeValid = isValid;
      });
    }
  }

  /// 다음 버튼 클릭 처리
  void _onNextPressed() {
    final code = _codeController.text.trim();
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('초대 코드를 입력해 주세요'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // TODO: API 호출하여 초대 코드 등록
    // 성공 시 다음 화면으로 이동
    // context.push('/invite-code-success');
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
          '코드 입력하기',
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 74),
            
            // 안내 텍스트
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E2E2E),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: '구성원에게 받은\n'),
                  TextSpan(
                    text: '초대 코드를 입력',
                    style: TextStyle(
                      color: Color(0xFFFF5F01),
                    ),
                  ),
                  TextSpan(text: '해 주세요'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // 도움말 텍스트
            Row(
              children: [
                const Text(
                  '아이디는 어디서 확인하나요?',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8C8B8B),
                  ),
                ),
                const SizedBox(width: 4),
                // 물음표 아이콘
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF5F01),
                  ),
                  child: const Center(
                    child: Text(
                      '?',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 7,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 36),
            
            // 초대 코드 입력 필드
            InviteCodeInputField(
              controller: _codeController,
              isValid: _isCodeValid,
            ),
            
            const Spacer(),
            
            // 다음 버튼
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
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
                    onTap: _onNextPressed,
                    child: const Center(
                      child: Text(
                        '다음',
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
          ],
        ),
      ),
    );
  }
}

